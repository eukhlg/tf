# Creating network

resource "yandex_vpc_network" "lamp-net" {
  name = local.lapm_network_name
}

# Creating subnet

resource "yandex_vpc_subnet" "lamp-net-subnet" {
  name           = local.lamp_subnet_name
  v4_cidr_blocks = ["10.158.78.0/24"]
  zone           = "ru-central1-b" #overriding default value
  network_id     = yandex_vpc_network.lamp-net.id
}

# Creating security group

resource "yandex_vpc_security_group" "lamp-security-group" {
  name        = local.lamp_sg_vm_name
  network_id  = yandex_vpc_network.lamp-net.id
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

 data "yandex_compute_image" "lamp" {
   family = "lamp"
 }

# Creating VM

 resource "yandex_compute_instance" "lamp-vm" {
    name        = local.lamp_vm_name
    platform_id = "standard-v3"
    zone        = "ru-central1-b" #overriding default value

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 1
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.lamp.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.lamp-net-subnet.id
    security_group_ids = [yandex_vpc_security_group.lamp-security-group.id]
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }

}
