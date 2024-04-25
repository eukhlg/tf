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


