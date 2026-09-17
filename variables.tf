###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to SSH public key"
}

variable "ip_address" {
  type        = string
  description = "IP-адрес"
  default     = "192.168.0.1"

  validation {
    condition     = can(cidrhost("${var.ip_address}/32", 0))
    error_message = "Значение должно быть корректным IPv4-адресом."
  }
}

variable "ip_addresses" {
  type        = list(string)
  description = "Список IP-адресов"
  default = [
    "192.168.0.1",
    "1.1.1.1",
    "127.0.0.1"
  ]

  validation {
    condition = alltrue([
      for ip in var.ip_addresses :
      can(cidrhost("${ip}/32", 0))
    ])
    error_message = "Все значения должны быть корректными IPv4-адресами."
  }
}
