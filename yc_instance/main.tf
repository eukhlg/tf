terraform {
    required_providers {
        yandex = {
        source  = "yandex-cloud/yandex"
        }
    }
}

# Getting data from source

data "yandex_compute_image" "family" {
  family = var.family
}


# Creating VM

resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = "standard-v3"
  zone        = var.vm_zone

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 1
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.family.id
    }
  }

  network_interface {
    subnet_id          = var.vm_subnet
    security_group_ids = var.vm_sg
    nat                = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }

}
