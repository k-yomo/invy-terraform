
resource "upstash_redis_database" "invy" {
  database_name = "invy-${local.env}"
  region = "ap-northeast-1"
  tls = true
}
