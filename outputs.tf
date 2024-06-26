output "access_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  sensitive = true
}
output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive = true
}

output "lemp_public_ip" {
  value = module.yc_instance-lemp.instance_public_ip
}

output "lamp_public_ip" {
  value = module.yc_instance-lamp.instance_public_ip
}

output "nlb_public_ip" {
  value = module.nlb.public_ip
}

# terraform output -raw secret_key
# terraform output -raw access_key