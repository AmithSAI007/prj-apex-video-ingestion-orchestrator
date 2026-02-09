"""
Apex Video Ingestion Orchestrator - core domain contract.

This module defines the orchestration flow for ingestion requests while avoiding any direct
infrastructure dependencies. Runtime-specific adapters (workflow engine, metadata service,
audit logging, etc.) must implement the protocols defined here and be injected into the
`IngestionOrchestrator` for production use.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Mapping, Protocol


@dataclass(frozen=True)
class IngestionRequest:
    """Represents an incoming request to ingest a video asset."""

    request_id: str
    tenant_id: str
    source_uri: str
    requested_at: datetime = field(default_factory=lambda: datetime.now(timezone.utc))
    metadata: Mapping[str, str] = field(default_factory=dict)


@dataclass(frozen=True)
class IngestionOutcome:
    """Captures the orchestration result for a request."""

    status: str
    workflow_id: str | None
    message: str


class RequestValidator(Protocol):
    """Validates an ingestion request against tenant and policy requirements."""

    def validate(self, request: IngestionRequest) -> None:
        """Raise an exception if the request fails validation."""


class MetadataEnricher(Protocol):
    """Enriches ingestion metadata with normalized or derived fields."""

    def enrich(self, request: IngestionRequest) -> Mapping[str, str]:
        """Return enriched metadata for the request."""


class WorkflowScheduler(Protocol):
    """Schedules the ingestion workflow in an external orchestration engine."""

    def schedule(self, request: IngestionRequest, metadata: Mapping[str, str]) -> str:
        """Return the workflow identifier created for the request."""


class AuditEmitter(Protocol):
    """Emits audit signals for observability and compliance."""

    def emit_success(self, request: IngestionRequest, workflow_id: str) -> None:
        """Emit a success event after the workflow is scheduled."""

    def emit_failure(self, request: IngestionRequest, error: Exception) -> None:
        """Emit a failure event whenever orchestration fails."""


class IngestionOrchestrator:
    """
    Coordinates the ingestion lifecycle with explicit, auditable steps.

    The orchestrator remains stateless aside from its injected collaborators, enabling
    safe reuse across threads and requests. All side effects are delegated to adapters,
    ensuring deterministic behavior in the orchestration flow.
    """

    def __init__(
        self,
        validator: RequestValidator,
        metadata_enricher: MetadataEnricher,
        scheduler: WorkflowScheduler,
        audit_emitter: AuditEmitter,
    ) -> None:
        self._validator = validator
        self._metadata_enricher = metadata_enricher
        self._scheduler = scheduler
        self._audit_emitter = audit_emitter

    def orchestrate(self, request: IngestionRequest) -> IngestionOutcome:
        """
        Execute the ingestion flow for a single request.

        Sequence:
        1. Validate the request for tenant, source, and policy compliance.
        2. Enrich metadata to normalize the request and derive additional context.
        3. Schedule the external workflow that performs the ingestion pipeline.
        4. Emit an audit event for observability.
        """

        try:
            # Step 1: Enforce tenant and policy validations before any side effects.
            self._validator.validate(request)

            # Step 2: Enrich metadata for downstream workflow execution.
            enriched_metadata = self._metadata_enricher.enrich(request)

            # Step 3: Schedule the workflow and capture the workflow identifier.
            workflow_id = self._scheduler.schedule(request, enriched_metadata)

            # Step 4: Emit a success audit signal for observability and compliance.
            self._audit_emitter.emit_success(request, workflow_id)

            return IngestionOutcome(
                status="scheduled",
                workflow_id=workflow_id,
                message="Ingestion workflow scheduled successfully.",
            )
        except Exception as exc:
            # Emit failure audits to preserve an immutable trail for investigations.
            self._audit_emitter.emit_failure(request, exc)
            raise
