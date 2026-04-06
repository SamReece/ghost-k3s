resource "kubernetes_secret_v1" "mysql_backup" {
  metadata {
    name      = "mysql-backup-secret"
    namespace = "ghost"
  }

  data = {
    MYSQL_USER     = var.mysql_user
    MYSQL_PASSWORD = var.mysql_password
    MYSQL_DATABASE = var.mysql_database
  }

  type = "Opaque"
}

resource "kubernetes_secret_v1" "rclone_config" {
  metadata {
    name      = "rclone-config"
    namespace = "default"
  }

  data = {
    "rclone.conf" = <<EOF
[contabo]
type = s3
provider = Other
env_auth = false
access_key_id = ${var.contabo_access_key}
secret_access_key = ${var.contabo_secret_key}
endpoint = ${var.contabo_endpoint}
acl = private
EOF
  }

  type = "Opaque"
}
