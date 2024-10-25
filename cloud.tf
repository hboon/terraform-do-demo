data "digitalocean_ssh_key" "terraform" {
  # Name should match the entry uploaded (can be viewed in the Digital Ocean dashboard)
  name = "terraform do"
}

resource "digitalocean_droplet" "vps" {
  image  = var.image
  name   = var.name
  region = var.region
  size   = var.server_size

  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  connection {
    host    = self.ipv4_address
    user    = "root"
    type    = "ssh"
    timeout = "2m"
  }

  user_data = data.cloudinit_config.cloud_config_vps.rendered
}

resource "digitalocean_firewall" "vps" {
  name = "only-22-80-and-443"

  //lifecycle {
  //prevent_destroy = true #protects firewall from being `terraform destroy`ed
  //}

  droplet_ids = [digitalocean_droplet.vps.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
