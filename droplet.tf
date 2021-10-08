variable "region" {
 default = "SFO3"
}

locals {
    instance_user = "${split(".", digitalocean_domain.mydomain.name)[0]}"
}

resource digitalocean_droplet "me" {
    count = 0
    name = "frontend-${count.index}"
    image = "ubuntu-20-04-x64"
    region = "SFO3"
    size = "s-1vcpu-1gb"
    ssh_keys = [
      data.digitalocean_ssh_key.lubuntu.id
    ]
    connection {
        host = self.ipv4_address
        user = "root"
        type = "ssh"
        private_key = file(var.pvt_key)
        timeout = "2m"
    }

    provisioner "remote-exec" {
        inline = [
            "export PATH=$PATH:/usr/bin",
            "ufw allow OpenSSH",
            "ufw --force enable",
            "sudo apt update",
            "sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -y --allow-downgrades --allow-remove-essential --allow-change-held-packages",
            "sudo adduser --disabled-password --gecos \"\" ${local.instance_user}",
            "usermod -aG sudo ${local.instance_user}",
            "rsync --archive --chown=${local.instance_user}:${local.instance_user} ~/.ssh /home/${local.instance_user}",
            # install nginx
            "sudo apt install -y nginx",
            "sudo ufw allow 'Nginx Full'",
            "sudo mkdir -p /var/www/${digitalocean_domain.mydomain.name}/html",
            "sudo apt install -y certbot python3-certbot-nginx"
        ]
    }
}