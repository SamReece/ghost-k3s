variable "mysql_user" {
  description = "MySQL username for backups"
  type        = string
  default     = "ghost"
}

variable "mysql_password" {
  description = "MYSQL password for backups"
  type        = string
  sensitive   = true
}

variable "mysql_database" {
  description = "Database name to back up"
  type        = string
  default     = "ghost"
}

variable "mysql_host" {
  type        = string
  default     = "mysql-service"
}

variable "contabo_access_key" {
  type      = string
  sensitive = true
}

variable "contabo_secret_key" {
  type      = string
  sensitive = true
}

variable "contabo_endpoint" {
  type    = string
  default = "https://eu2.contabostorage.com"
}

variable "contabo_bucket" {
  type    = string
  default = "ghost-backups"
}

variable "backup_schedule" {
  type    = string
  default = "0 2 * * *" # daily at 2 AM
}
