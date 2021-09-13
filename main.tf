resource "google_compute_network" "vpc_network" {
  name = "${var.project}-vpc"
  auto_create_subnetworks = false
}