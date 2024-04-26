terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

# Creating network

resource "yandex_vpc_network" "network" {
  name = var.network_name
}