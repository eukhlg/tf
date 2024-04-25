output "access_key" {
    value = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    sensitive = true
}
output "secret_key" {
    value = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    sensitive = true
}

# terraform output -raw secret_key
# terraform output -raw access_key

output "public_ip" {
    value = yandex_compute_instance.lemp-vm.network_interface.0.nat_ip_address
}

