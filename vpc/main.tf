terraform {
    required_providers {
        yandex = {
        source  = "yandex-cloud/yandex"
        }
    }
}

# Creating network

resource "yandex_vpc_network" "network" {
  name = var.network_name
}

# Creating subnet

resource "yandex_vpc_subnet" "network-subnet" {
  name           = var.subnet_name
  v4_cidr_blocks = var.subnet_scope
  zone           = var.subnet_zone
  network_id     = yandex_vpc_network.network.id
}

# Creating security group

resource "yandex_vpc_security_group" "security-group" {
  name       = var.sg_name
  network_id = yandex_vpc_network.network.id
  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }
  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  # SSH access from authorized IP

  ingress {
    protocol       = "TCP"
    description    = "ext-ssh"
    v4_cidr_blocks = ["83.242.181.181/32"]
    port           = 22
  }

}