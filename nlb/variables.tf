variable "nlb_name" {
  type = string
}

variable "listener_name" {
  type = string
}

variable "tg_name" {
  type = string
}

variable "targets" {
  type = list(object({
    address = string
    subnet_id = string
  }))
}