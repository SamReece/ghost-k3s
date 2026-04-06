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
