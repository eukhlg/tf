terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_storage_bucket" "bucket" {
  access_key = var.access_key
  secret_key = var.secret_key
  bucket     = var.bucket_name

}