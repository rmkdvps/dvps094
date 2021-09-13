resource "google_compute_network" "vpc_network" {
  name = "test2-vpc"
  auto_create_subnetworks = false
}
