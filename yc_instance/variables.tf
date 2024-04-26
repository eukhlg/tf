variable "vm_user" {
  description = "Instance admin"
  type        = string
  default     = "vm_user"
}

# export TF_VAR_vm_user=

variable "ssh_key_path" {
  description = "Path to SSH key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

# export TF_VAR_ssh_key_path=

variable "family" {
  type = string
}

variable "vm_zone" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_subnet" {
  type = string
}

variable "vm_sg" {
  type = set(string)
}
