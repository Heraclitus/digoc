variable "project_name" {}
variable "my_ssh_ip" {

}

resource "digitalocean_domain" "mydomain" {
   name       = var.project_name
}

resource "digitalocean_record" "A_noprefix" {
  type = "A"
  ttl  = 300
  name = "@"
  value = digitalocean_floating_ip.mydomain.ip_address
  domain = digitalocean_domain.mydomain.name
}

resource "digitalocean_record" "A" {
  type = "A"
  name = "www"
  ttl  = 300
  value = digitalocean_floating_ip.mydomain.ip_address
  domain = digitalocean_domain.mydomain.name
}

resource "digitalocean_floating_ip" "mydomain" {
  region = var.region
  droplet_id = 264173603
}

resource "digitalocean_firewall" "firewall" {
  name  = var.project_name
  tags  = ["frontend"]
  count = "1"

  inbound_rule {
      protocol                = "tcp"
      port_range              = "22"
      source_addresses        = ["${var.my_ssh_ip}/32"]
    }
  inbound_rule {
      protocol                = "tcp"
      port_range              = "80"
      source_addresses        = ["0.0.0.0/0", "::/0"]
    }
  inbound_rule {
      protocol                = "tcp"
      port_range              = "443"
      source_addresses        = ["0.0.0.0/0", "::/0"]
    }

  outbound_rule {
      protocol                = "tcp"
      port_range              = "all"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    }
  outbound_rule {
      protocol                = "udp"
      port_range              = "all"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    }
  outbound_rule {
      protocol                = "icmp"
      destination_addresses   = ["0.0.0.0/32"]
    }
}