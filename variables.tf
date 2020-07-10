variable "environment_name" {
  type = string
}

variable "owner_name" {
  type = string
}

variable "ttl" {
  type    = number
  default = 48
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "network" {
  type = string
}

variable "subnet" {
  type = string
}

variable "tags" {
  type    = map
  default = null
}

variable "node_count" {
  type    = number
  default = 3
}

variable "node_locations" {
  type    = list(string)
  default = null
}

variable "machine_size" {
  type    = string
  default = "n1-standard-2"
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "oauth_scopes" {
  type = list(string)
  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

variable "service_account" {
  type    = string
  default = null
}

variable "http_load_balancing" {
  type    = bool
  default = false
}
