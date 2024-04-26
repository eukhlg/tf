output "vpc_subnet" {
  value = yandex_vpc_subnet.network-subnet.id
}

output "vpc_sg" {
  value = yandex_vpc_security_group.security-group.id
}