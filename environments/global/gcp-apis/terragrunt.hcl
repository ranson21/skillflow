include "parent" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "git@github.com:terraform-google-modules/terraform-google-project-factory//modules/project_services"
}

inputs = {
  project_id                  = include.parent.locals.project
  disable_services_on_destroy = false
  activate_apis = [
    "cloudbilling.googleapis.com",
    "cloudidentity.googleapis.com",
    "cloudfunctions.googleapis.com",
    "billingbudgets.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudtrace.googleapis.com",
    "cloudbuild.googleapis.com",
    "iamcredentials.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "iap.googleapis.com"
  ]
}
