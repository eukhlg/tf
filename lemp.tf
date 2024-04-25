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

# SSH access from authorized IP

ingress {
    protocol       = "TCP"
    description    = "ext-ssh"
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
