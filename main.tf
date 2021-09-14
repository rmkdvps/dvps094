resource "google_compute_instance" "vm_instance" {
  name = "cloudbuild-instance"
  machine_type = var.machine_type
  zone = var.zone

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-8"
    }
  }

  network_interface {
    # subnetwork = google_compute_subnetwork.vpc_subnetwork.name
    # access_config {
    # }
    }

  metadata_startup_script = "echo hi > /test.txt"

}