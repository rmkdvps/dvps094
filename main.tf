# =============== networks and firewall =================

resource "google_compute_network" "vpc_network" {
  name = "${var.project}-vpc"
  auto_create_subnetworks = false
  project = var.project
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "${var.project}-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  project = var.project
}

resource "google_compute_firewall" "firewall_rules" {
  project = var.project
  name    = "firewall-rules"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports = ["80", "444", "55000", "5000", "5001", "5671", "5672", "5673", "15672", "8080"]
  }

  target_tags = ["app"]
}

# =============== db =================
resource "random_id" "db_name" {
  byte_length = 8
}

resource "google_sql_database" "post_db" {
  name     = random_id.db_name.hex
  instance = google_sql_database_instance.machine.name
}

resource "random_id" "db_instance_name" {
  byte_length = 3
}

resource "google_sql_database_instance" "machine" {
  # name             = "db_machine-${random_id.db_instance_name.hex}"
  database_version = "POSTGRES_13"
  region           = var.region
  project          = var.project

  settings {
    tier = "db-f1-micro"
    disk_size = var.disk_size
  }

  deletion_protection  = "false"

}

resource "google_sql_user" "postgresql_user" {
  name = var.db_user
  project  = var.project
  instance = google_sql_database_instance.machine.name
  password = var.db_password
}

# =============== GKE =================

resource "google_container_cluster" "primary" {
  name     = "${var.project}-gke-cluster"
  location = var.location
  
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.vpc_subnetwork.name
}

data "google_client_config" "default" {}

# provider "kubernetes" {
  
#   host     = "https://${data.google_container_cluster.primary.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = data.google_container_cluster.primary.cluster_ca_certificate
# }

# provider "kubernetes" {
#   load_config_file = false

#   host  = "https://${data.google_container_cluster.primary.endpoint}"
#   token = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
#   )
# }

# provider "helm" {
#   kubernetes {
#     host = "https://${data.google_container_cluster.primary.endpoint}"

#   }
# }


resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project
    }

    # preemptible  = true
    machine_type = "e2-medium"
    tags         = ["gke-node", "${var.project}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}