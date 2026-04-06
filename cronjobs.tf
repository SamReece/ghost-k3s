resource "kubernetes_cron_job_v1" "ghost_mysql_backup" {
  metadata {
    name      = "ghost-mysql-backup"
    namespace = "ghost"
  }

  spec {
    schedule                      = var.backup_schedule
    successful_jobs_history_limit = 3
    failed_jobs_history_limit     = 1

    job_template {
      metadata {}
      spec {
        template {
          metadata {}
          spec {
            restart_policy = "OnFailure"

            container {
              name  = "mysql-backup"
              image = "ubuntu:22.04" # We'll install mysql-client & rclone

              env_from {
                secret_ref {
                  name = kubernetes_secret_v1.mysql_backup.metadata[0].name
                }
              }

              volume_mount {
                name       = "backup-storage"
                mount_path = "/backup"
              }

              volume_mount {
                name       = "rclone-config"
                mount_path = "/root/.config/rclone"
              }

              command = ["/bin/sh", "-c"]
              args = [<<-EOF
                apt-get update && \
                apt-get install -y mysql-client rclone gzip && \
                TIMESTAMP=$(date +%F_%H-%M-%S) && \
                BACKUP_FILE="/backup/ghost_$TIMESTAMP.sql.gz" && \
                echo "Dumping database..." && \
                mysqldump -h ${var.mysql_host} -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE | gzip > $BACKUP_FILE && \
                echo "Uploading to Contabo..." && \
                rclone copy --no-check-certificate $BACKUP_FILE contabo:${var.contabo_bucket}/
              EOF
              ]
            }

            volume {
              name = "backup-storage"
              empty_dir {}
            }

            volume {
              name = "rclone-config"
              secret {
                secret_name = kubernetes_secret_v1.rclone_config.metadata[0].name
              }
            }
          }
        }
      }
    }
  }
}
