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

output "network_settings" {
    value = yandex_compute_instance.lemp-vm.network_interface # Didn't find how to get just Public IP from the list
}

