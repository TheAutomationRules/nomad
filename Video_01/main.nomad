job "redis" {
  datacenters = ["dc1"]

  group "cache" {
    count = 2
    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image          = "redis:7"
        ports          = ["db"]
        auth_soft_fail = true
      }

      resources {
        cpu    = 500 # Megahercios
        memory = 256 # Megabytes
      }
    }

  }

}