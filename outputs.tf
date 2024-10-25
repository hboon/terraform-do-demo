output "ipv4_address" {
  value       = digitalocean_droplet.vps.ipv4_address
  description = "The public IP address of your Droplet application."
}
