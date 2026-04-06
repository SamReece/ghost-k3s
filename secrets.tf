resource "kubernetes_secret" "mysql_backup" {
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
