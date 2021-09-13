# =============== provider =================
variable "region" {
  description = "gcp region"
  default     = "europe-central2"
}

variable "project" {
  description = "name of the project"
  default     = "softserve-project"
}

variable "project_id" {
  description = "name of the project"
  default     = "softserve-project"
}

variable "zone" {
  description = "gcp zone"
  default     = "europe-central2-a"
}

variable "location" {
  description = "gcp location"
  default     = "europe-central2-a"
}

# =============== db =================

variable "machine_type" {
  description = "instance macine type"
  default     = "e2-micro"
}

variable "disk_size" {
  description = "db disk_size"
  default     = "10"
}

variable "db_user" {
  description = "db user"
  default     = "postgresql"
}

variable "db_password" {
  description = "db pass"
  default     = "postgresql"
}

# =============== GKE =================

variable "cluster_name" {
  description = "k8s cluster_name"
  default     = "dev094"
}

# =============== GCB =================
variable "github_repository" {
    default = "dvps094"
}

variable "github_owner" {
    default = "rmkdvps"
}

variable "github_branch" {
    default = "^master$"
}
