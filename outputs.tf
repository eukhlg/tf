output "access_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  sensitive = true
}
output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive = true
}

output "instance_public_ip" {
  value = module.yc_instance.instance_public_ip
}


# terraform output -raw secret_key
# terraform output -raw access_key