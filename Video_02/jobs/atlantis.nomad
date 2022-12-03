locals {
  username        = "ghcodename"
  token           = "ghp_TbSAzIHXYT5b92hW02WP5TEqqcLwQ4HrjZ6K"
  repo_allow_list = "*"
  secret          = "hwxdidmyzvebzkukhslqhdbb"
}

job "atlantis" {
  datacenters = ["nuc"]

  group "terraform" {
    count = 1

    network {
      port "atlantis" {
        to = 4141
      }
    }

    service {
      provider = "consul"
      port     = "atlantis"

      check {
        type     = "tcp"
        port     = "atlantis"
        interval = "10s"
        timeout  = "2s"
      }

      check {
        type     = "http"
        name     = "app_health"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    volume "atlantis-data" {
      type      = "host"
      source    = "atlantis-data"
      read_only = false
    }

    volume "atlantis-config" {
      type      = "host"
      source    = "atlantis-config"
      read_only = true
    }

    task "atlantis" {
      driver = "docker"
      config {
        image   = "ghcr.io/runatlantis/atlantis:v0.20.1"
        ports   = ["atlantis"]
        #auth_soft_fail = true
        command = "server"
        args    = [
          "--gh-user=${local.username}",
          "--gh-token=${local.token}",
          "--repo-allowlist=${local.repo_allow_list}",
          "--gh-webhook-secret=${local.secret}",
          "--log-level=debug",
          "--repo-config=/home/atlantis/config/repos.yaml",
          "--atlantis-url=http://nuc.lan:4141"
        ]

        labels {
          service = "atlantis"
          used_by = "terraform"
          group   = "webservice-gitops"
        }
      }

      volume_mount {
        volume      = "atlantis-data"
        destination = "/home/atlantis/.atlantis"
        read_only   = false
      }

      volume_mount {
        volume      = "atlantis-config"
        destination = "/home/atlantis/config"
        read_only   = true
      }

    }

  }

}