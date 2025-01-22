include "parent" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${include.parent.locals.source}/tf-gcp-project"
}

inputs = {
  project_id   = include.parent.locals.project
  region       = include.parent.locals.region
  project_name = "RaNor Skillflow"

  # Billing and budget configuration
  billing_account = include.parent.locals.billing_account
  budget_name     = "portfolio-billing"
  budget_amount   = "30"
  budget_topic    = "budget_monitor"

  labels = {
    "firebase" = "enabled"
  }
}


dependency "apis" {
  config_path = "../gcp-apis"
  mock_outputs_allowed_terraform_commands = [
    "init",
    "validate",
    "plan",
  ]
  mock_outputs = {
    project = ""
  }
}