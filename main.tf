resource "google_compute_network" "vpc_network" {
  name = "test-vpc"
  auto_create_subnetworks = false
}
