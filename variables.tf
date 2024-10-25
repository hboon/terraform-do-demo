variable "host_api_key" {
  description = "The Web Host Cloud API Token"
  type        = string
}

variable "ssh_vps_kamal_key" {
  description = "SSH public key for the user kamal"
  type        = string
}

variable "server_size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "image" {
  type    = string
  default = "ubuntu-20-04-x64"
}

variable "region" {
  type    = string
  default = "nyc3"
}

variable "name" {
  type    = string
  default = "vps"
}
