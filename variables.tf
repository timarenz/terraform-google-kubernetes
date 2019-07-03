variable "environment_name" {
  type = string
}

variable "owner_name" {
  type    = string
  default = null
}

variable "ttl" {
  type    = number
  default = 48
}

variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west4"
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
