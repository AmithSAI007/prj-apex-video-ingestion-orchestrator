# prj-apex-video-ingestion-orchestrator

## Overview

This repository defines the infrastructure and workflow orchestration for the Apex video ingestion
pipeline on Google Cloud. Terraform modules wire together Eventarc triggers, Cloud Workflows,
Pub/Sub, Cloud Storage, and Firestore so that uploaded videos automatically kick off Transcoder jobs
and downstream metadata updates.

## Architecture Flow

1. **Raw upload**: A video is uploaded to the raw Cloud Storage bucket.
2. **Ingestion workflow**: Eventarc invokes the ingestion workflow on object finalization and creates the Firestore record idempotently.
3. **Transcoding**: The worker workflow starts a Transcoder job, records the job ID, and marks processing when appropriate.
4. **Completion workflow**: Transcoder publishes a Pub/Sub message and Eventarc routes it to the
   completion workflow, which updates Firestore with the job outcome.

## Repository Layout

- `terraform/environments/development`: Environment composition and backend configuration.
- `terraform/modules/iam`: Service account lookup for workflow execution.
- `terraform/modules/storage`: Existing raw/processed Cloud Storage buckets.
- `terraform/modules/pubsub`: Existing Pub/Sub topic used for completion events.
- `terraform/modules/triggers`: Eventarc triggers for ingestion and completion workflows.
- `terraform/modules/workflows`: Cloud Workflows definitions and environment variables.
- `workflows/storage-ingestion-workflow.yaml`: Ingestion workflow definition.
- `workflows/transcoder-completion-workflow.yaml`: Completion workflow definition.
- `workflows/transcoder-worker-workflow.yaml`: Worker workflow triggered by Cloud Tasks.

## Prerequisites

- Terraform 1.x installed locally.
- A Google Cloud project with the following APIs enabled:
  - Cloud Workflows
  - Eventarc
  - Pub/Sub
  - Transcoder API
  - Firestore
  - Cloud Storage
- Existing Cloud Storage buckets for raw and processed video assets.
- A Pub/Sub topic that receives Transcoder completion notifications.
- A service account with permission to run Eventarc and Workflows actions.

## Configuration

Provide environment-specific values in `terraform/environments/development/terraform.tfvars` or via
`-var` arguments. Key inputs include:

| Variable                       | Description                                     |
| ------------------------------ | ----------------------------------------------- |
| `project_id`                   | Google Cloud project identifier.                |
| `project_region`               | Region for Eventarc and Workflows.              |
| `service_account_name`         | Service account that executes workflows.        |
| `transcoder_template_id`       | Transcoder template for video processing jobs.  |
| `workflow_name`                | Name for the ingestion workflow.                |
| `completion_workflow_name`     | Name for the completion workflow.               |
| `worker_workflow_name`         | Name for the worker workflow.                   |
| `firestore_db_name`            | Firestore database used for video metadata.     |
| `completion_pubsub_topic_name` | Pub/Sub topic for Transcoder completion events. |

Example `terraform.tfvars`:

```hcl
project_id                   = "my-gcp-project"
project_region               = "us-central1"
service_account_name         = "apex-video-orchestrator-svc"
transcoder_template_id       = "projects/my-gcp-project/locations/us-central1/templates/my-template"
workflow_name                = "apex-storage-ingestion-workflow"
completion_workflow_name     = "apex-transcoder-completion-workflow"
worker_workflow_name         = "apex-transcoder-worker-workflow"
firestore_db_name            = "(default)"
completion_pubsub_topic_name = "apex-transcoder-status-topic"
```

## Deploying

```bash
cd terraform/environments/development
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

> Note: Terraform modules reference existing buckets and Pub/Sub topics via data sources. Ensure
> those resources exist before applying.

## Workflows Summary

- **Ingestion workflow (`workflows/storage-ingestion-workflow.yaml`)**: Initializes metadata, creates the Firestore record, and enqueues the worker task.
- **Completion workflow (`workflows/transcoder-completion-workflow.yaml`)**: Reads Pub/Sub completion messages,
  fetches job details, and updates Firestore with final status and resolution.
- **Worker workflow (`workflows/transcoder-worker-workflow.yaml`)**: Starts Transcoder jobs and Video Intelligence annotations, records the job ID, and conditionally updates processing state to avoid overwriting terminal statuses.

## Observability

Both workflows emit structured logs via `sys.log`, which surface in Cloud Logging for debugging and
operational dashboards.
