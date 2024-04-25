variable "vpc_net" {
    type = string
}

variable "subnet_name" {
    type = string
}

variable "subnet_scope" {
    type = list(string)
}

variable "subnet_zone" {
    type = string
}
variable "sg_name" {
    type = string
}