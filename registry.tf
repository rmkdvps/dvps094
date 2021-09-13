resource "google_project_service" "service" {
    for_each = toset([
        "artifactregistry.googleapis.com"
    ])

    service = each.key

    project            = var.project
    disable_on_destroy = false
}

resource "google_artifact_registry_repository" "my-repository" {
    provider        = google-beta
    location        = var.region
    repository_id   = "my-repository"
    format          = "DOCKER"
    depends_on      = [google_project_service.service["artifactregistry.googleapis.com"]
 ]
}