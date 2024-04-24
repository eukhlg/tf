variable "token" {
    description = "YC OAuth token"
    type        = string   
    default     = "token" # where to take? - https://yandex.cloud/en-ru/docs/iam/concepts/authorization/oauth-token?
}

# export TF_VAR_token=

variable "cloud_id" {
    description = "YC Cloud ID"
    type        = string
    default     = "cloud_id" # where to take? - Web UI or CLI  
}

# export TF_VAR_cloud_id=

variable "folder_id" {
    description = "YC Folder ID"
    type        = string
    default     = "folder_id" # where to take? - Web UI or CLI
}

# export TF_VAR_folder_id=

variable "zone" {
    description = "YC Compute Zone"
    type        = string
    default     = "ru-central1-b" # where to take? - Web UI or CLI
}

# Adding locals

locals {
  network_name       = "lemp-net"
  subnet_name        = "lemp-net-subnet"
  sg_vm_name         = "lemp-security-group"
  vm_name            = "lemp-vm"
  dns_zone_name      = "lemp-dns-zone"
}