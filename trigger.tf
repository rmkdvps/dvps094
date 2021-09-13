resource "google_cloudbuild_trigger" "my-trigger" {
    provider = google-beta
    name = "hello-world"

    github {
        name = var.github_repository
        owner = var.github_owner
        push {
            branch = var.github_branch
        }
    }

    filename = "cloudbuild.yaml"
}