locals {
  cloudbuild-roles = [
    "roles/container.developer",
    "roles/secretmanager.secretAccessor",
  ]

  developer-roles = [
    "roles/cloudbuild.builds.editor",
    "roles/owner",
  ]

  gke-roles = [
    "roles/artifactregistry.reader",
    "roles/cloudsql.client",
    "roles/cloudsql.viewer",
    "roles/cloudtrace.agent",
    "roles/pubsub.publisher",
    "roles/pubsub.subscriber",
    "roles/secretmanager.secretAccessor",
    "roles/storage.objectAdmin",
  ]
}