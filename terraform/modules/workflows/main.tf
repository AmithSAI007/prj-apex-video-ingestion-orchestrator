resource "google_workflows_workflow" "workflow" {
  for_each = var.workflows

  name                    = each.value.name
  region                  = var.project_region
  description             = try(each.value.description, "Workflow for ${each.value.name}")
  service_account         = var.service_account_name
  execution_history_level = var.execution_history_level

  source_contents = each.value.source_contents

  user_env_vars = each.value.env_vars
}
