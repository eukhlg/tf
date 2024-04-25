terraform {
    required_providers {
        yandex = {
        source  = "yandex-cloud/yandex"
        version = "= 0.116.0"
    }
  }
    required_version = "= 1.8.1"
}

provider "yandex" {
    token                    = var.token
    cloud_id                 = var.cloud_id
    folder_id                = var.folder_id
    zone                     = var.zone
}

resource "yandex_iam_service_account" "sa" {
    folder_id = var.folder_id
    name = "sa-sf"
  
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
    folder_id = var.folder_id
    role = "storage.editor"
    member = "serviceAccount:${yandex_iam_service_account.sa.id}"
  
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
    service_account_id = yandex_iam_service_account.sa.id
    description = "this is static access key for object storage"
}

# Creating network

resource "yandex_vpc_network" "lemp-net" {
  name = local.network_name
}

# Creating subnet

resource "yandex_vpc_subnet" "lemp-net-subnet" {
  name           = local.subnet_name
  v4_cidr_blocks = ["10.158.77.0/24"]
  zone           = var.zone
  network_id     = yandex_vpc_network.lemp-net.id
}

# Creating security group

resource "yandex_vpc_security_group" "lemp-security-group" {
  name        = local.sg_vm_name
  network_id  = yandex_vpc_network.lemp-net.id
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

ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["83.242.181.181/32"]
    port           = 22
  }

}

# Getting data from source

 data "yandex_compute_image" "lemp" {
   family = "lemp"
 }

# Creating VM

 resource "yandex_compute_instance" "lemp-vm" {
    name        = local.vm_name
    platform_id = "standard-v3"
    zone        = var.zone

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 1
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.lemp.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.lemp-net-subnet.id
    security_group_ids = [yandex_vpc_security_group.lemp-security-group.id]
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }

}


