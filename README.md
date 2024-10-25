Related [blog post](https://hboon.com/terraform-and-kamal-for-digital-ocean-demo-repositories/).

This is a demo repo for provisioning a single server using [Terraform](https://www.terraform.io) on Digital Ocean.

This is primary designed (but not limited) to run app servers that are deployed using Kamal (hence user created named `kamal`).

After provisioning a server, you can use Kamal with [this demo repo that shows how to deploy an app that runs a node.js/bun frontend + backend + database stack](https://github.com/hboon/kamal-frontend-backend-demo)

## Quick Start

1. Generate two pairs of SSH keys, one for the root user and one for the kamal user (something like `ssh-keygen -t ed25519 -C "<name or email>")
2. Generate a new API key in Digital Ocean web console
3. Upload the root user public key to the Digital Ocean web console and replace `"terraform do"` in `cloud.tf` with it
4. Create a file `terraform.tfvars` at the root of the repository with your Digital Ocean API key and SSH key to be used for kamal, it will look like this:
   ```terraform
   host_api_key = "your-digital-ocean-api-key"
   ssh_vps_kamal_key = "<your-ssh-kamal-public-key>"
   ```
   There are additional variables you can set; but they have defaults. Check `variables.tf`.
5. Run `terraform init` to initialize the terraform environment
6. Run `terraform plan` to see the changes that will be applied
7. Run `terraform apply` (and when prompted, type `yes` and hit enter) to apply the changes
8. When this is done, the new droplet should appear in the Digital Ocean web console. You should also see a firewall in the web console
9. Copy the IP address of the droplet
10. Run `ssh root@<ip address>`. You might need to retry (a few times) after a few seconds if it doesn't connect yet
11. Run `echo $SHELL` and it is probably `/bin/bash`. If so, wait at the prompt until the machine says it's rebooting. This will happen after a few minutes, but unlikely to take more than 10 minutes.
12. Run step 10-11 again and this time, `echo $SHELL` should say `/bin/fish`

## Tips and Troubleshooting

As you tweak the configuration, it'll be useful to do:

1. Run `terraform apply`
2. Run `terraform destroy`
3. Tweak configuration files
4. Run `rm *.tfstate *.tfstate.backup; terraform apply`
5. Repeat 2-5

Depending on what you do (usually because you didn't do `terraform destroy` and manually deleted the droplets in the web console), sometimes you might find that the firewall objects aren't destroyed and `rm *.tfstate *.tfstate.backup; terraform apply` would then fail.

You can import the existing firewall object:

1. With your API key, run `curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer <api key>" "https://api.digitalocean.com/v2/firewalls"` and look up the `id` for the fire wall and then:
2. Run `terraform import digitalocean_firewall.vps <firewall id>`
3. `terraform apply` (without deleting the `*.tfstate` files)

## Acknowledgements

This script is based on the great work of [dylanjcastillo](https://github.com/dylanjcastillo) in [terraform-kamal-single-vps](https://github.com/dylanjcastillo/terraform-kamal-single-vps) which is in turn based on [luizkowalski](https://github.com/luizkowalski) in [terraform-hetzner](https://github.com/luizkowalski/terraform-hetzner).
