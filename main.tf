terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "= 0.116.0"
    }
  }
  required_version = "= 1.8.1"

  /*
    backend "s3" {
    endpoints = {
      s3 = "storage.yandexcloud.net"
    }
    bucket = "tf-bucket-eukhlg"
    region = "ru-central1"
    key    = "tfstate/terraform.tfstate"
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # This option is required to describe backend for Terraform version 1.6.1 or higher.
    skip_s3_checksum            = true # This option is required to describe backend for Terraform version 1.6.3 or higher.
  }
  */
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder_id
  name      = "sa-sf"

}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"

}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

module "vpc" {
  source = "./vpc"
  sg_name      = "lemp_sg"
  network_name = "vpc_network"
  subnet_name  = "lemp_subnet"
  subnet_scope = ["10.158.77.0/24"]
  subnet_zone  = "ru-central1-a"
  
}

module "yc_instance" {
  source  = "./yc_instance"
  vm_user = "praetorian"
  family  = "lemp"
  vm_zone = "ru-central1-a"
  vm_name = "lemp_vm"
  vm_subnet = module.vpc.vpc_subnet
  vm_sg = [module.vpc.vpc_sg]
}