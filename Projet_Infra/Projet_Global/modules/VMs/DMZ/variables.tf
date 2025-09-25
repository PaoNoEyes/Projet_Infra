variable "vm_name" {
  type        = string
  default     = "DMZ_WEB_SFTP"
}

variable "datastore" {
  default     = "ESX-DSS-GESTION-local-storage2"
}

variable "OVAs_Path" {
  type        = string
  default     = "/media/disk2/OVA/"
}

variable "esxi_host" {
  type        = string
  default     = "192.168.127.64"
}

variable "esxi_user" {
  type        = string
  default     = "gelly"
}

variable "esxi_password" {
  type        = string
  default     = "Kiki2025.16!!"
}
