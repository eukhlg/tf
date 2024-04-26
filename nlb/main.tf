terraform {
    required_providers {
        yandex = {
        source  = "yandex-cloud/yandex"
        }
    }
}

resource "yandex_lb_target_group" "web-servers" {
  name = var.tg_name

    dynamic "target" {
        for_each = var.targets
        content {
            subnet_id = target.value["subnet_id"]
            address   = target.value["address"]
    }
    }

}

resource "yandex_lb_network_load_balancer" "one" {
  name = var.nlb_name

  listener {
    name = var.listener_name
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

 attached_target_group {
    target_group_id = yandex_lb_target_group.web-servers.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }

}

