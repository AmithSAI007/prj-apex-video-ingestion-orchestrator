# AGENTS.md

## 1. Build, Lint, and Test

### Infrastructure (Terraform)
This project uses Terraform for Infrastructure as Code. There is no top-level `package.json` or `Makefile`.

*   **Initialize:**
    Navigate to the environment directory before running commands.
    ```bash
    cd terraform/environments/development
    terraform init
    ```
    *Note: Ensure `provider.tf` is correctly configured or symlinked from `terraform/shared/provider.tf` if missing in the environment dir.*

*   **Plan (Dry Run):**
    ```bash
    terraform plan -var-file=terraform.tfvars
    ```

*   **Apply (Deploy):**
    ```bash
    terraform apply -var-file=terraform.tfvars
    ```

*   **Format:**
    Run this from the project root to format all Terraform files recursively.
    ```bash
    terraform fmt -recursive
    ```

*   **Validate:**
    Checks for syntax errors and internal consistency.
    ```bash
    cd terraform/environments/development
    terraform validate
    ```

### Workflows (YAML)
*   **Validation:**
    There is no automated local linter for Google Cloud Workflows YAML files currently configured.
    *   Ensure YAML syntax is valid.
    *   Verify `sys.get_env` variable names match those injected in `terraform/modules/workflows/main.tf`.

### CI/CD (GitHub Actions)
*   **Workflow:** `.github/workflows/main.yaml` handles deployment.
*   **Trigger:** Manual dispatch (`workflow_dispatch`), push to `main`/`develop`, or PRs.
*   **Logic:**
    1.  Determines environment (dev/prod).
    2.  Creates a temporary `deploy.tfvars.json`.
    3.  Calls a reusable workflow `AmithSAI007/prj-apex-infrastructure/.../reusable-terraform-core.yaml`.

## 2. Code Style & Conventions

### General
*   **Pathing:** Always use **absolute paths** when referencing files in tool calls.
*   **Root Directory:** `/Users/amith/Github/prj-apex-video-ingestion-orchestrator`

### Terraform (`.tf`)
*   **Formatting:** Strict adherence to `terraform fmt`.
*   **Naming:**
    *   **Resources:** `snake_case` (e.g., `google_storage_bucket`, `video_orchestrator`).
    *   **Variables:** `snake_case` with descriptive names (e.g., `project_id`, `transcoder_template_id`).
    *   **Outputs:** Clear, concise names indicating the value returned.
*   **Structure:**
    *   **Environments:** `terraform/environments/<env>/` contains the root configuration for deployments.
    *   **Modules:** `terraform/modules/<module_name>/` contains reusable logic.
    *   **Shared:** `terraform/shared/` contains common provider configs.
*   **Best Practices:**
    *   Use `var.` for all dynamic input values.
    *   Use `module.` to reference outputs from other modules.
    *   Do not hardcode project IDs or regions; inject them via variables.
    *   **Versions:** Provider versions are pinned in `terraform/shared/provider.tf` (currently `hashicorp/google ~> 7.16.0`).

### Cloud Workflows (`.yaml`)
*   **Formatting:** Standard YAML indentation (2 spaces).
*   **Structure:**
    *   **Main Block:** `main:` defines the entry point.
    *   **Params:** `params: [event]` for event-triggered workflows.
    *   **Steps:** Linear sequence of operations.
*   **Variables:**
    *   Use `sys.get_env("VAR_NAME")` to access environment variables.
    *   Define local variables in an `init` step using `assign`.
*   **Idempotency:**
    *   Avoid overwriting terminal Firestore statuses (`COMPLETED`, `FAILED`, `ERROR`).
    *   When Cloud Tasks retries are possible, re-check status before writing non-terminal updates.
*   **Error Handling:**
    *   Use `try/except` blocks for external API calls (e.g., `googleapis.transcoder...`, `http.post`).
    *   Log errors using `sys.log` with `severity: "ERROR"` before raising or failing.
    *   Update Firestore status to "ERROR" on failure.

### Documentation
*   **Comments:**
    *   Terraform: Add comments above `module` and `resource` blocks explaining *why* they exist.
    *   Workflows: Comment complex steps or non-obvious variable transformations.
*   **README:** Keep `README.md` updated if architecture changes.

## 3. Architecture Overview
*   **Flow:** Upload -> Eventarc -> Ingestion Workflow -> Transcoder -> Pub/Sub -> Completion Workflow -> Firestore.
*   **State:** Firestore tracks the video processing status (`PENDING` -> `PROCESSING` -> `COMPLETED`/`ERROR`).

## 4. Environment
*   **Platform:** Darwin (macOS)
*   **Git:** Enabled
