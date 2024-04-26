output "public_ip" {
  value = [for s in yandex_lb_network_load_balancer.one.listener : s.external_address_spec.*.address].0[0]
}