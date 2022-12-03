data_dir   = "/var/lib/nomad/data"
plugin_dir = "/var/lib/nomad/plugin"
log_level  = "INFO"

bind_addr  = "0.0.0.0" # the default
datacenter = "nuc"
name       = "intelnuc"

region = "global"

advertise {
  # Defaults to the first private IP address.
  http = "192.168.50.16"
}

server {
  enabled          = true
  bootstrap_expect = 1 # Number of NODES
}

vault {
  enabled          = true
  #ca_path	= "/etc/certs/ca"
  #cert_file	= "/var/certs/vault.crt"
  #key_file	= "/var/certs/vault.key"
  address          = "http://nuc.lan:8200"
  token            = "s.b6JkMI7cMYMyU4CxTRTofUp4"
  task_token_ttl   = "1h"
  #allow_unauthenticated = true # Default false
  create_from_role = "nomad-server"
}

client {
  enabled               = true
  bridge_network_name   = "docker0"
  bridge_network_subnet = "172.17.0.1/16"

  host_volume "ca-certificates" {
    path      = "/etc/ssl/certs"
    read_only = true
  }

  host_volume "atlantis-data" {
    path      = "/home/rockemsockem/Services/Data/atlantis/data"
    read_only = false
  }

  host_volume "atlantis-config" {
    path      = "/home/rockemsockem/Services/Data/atlantis/config"
    read_only = true
  }

}
# CLIENT END

plugin "raw_exec" {
  config {
    enabled = true
  }
}

consul {
  address               = "http://nuc.lan:8500"
  allow_unauthenticated = true
}

#tls = false

ui {
  enabled = true

  consul {
    ui_url = "http://nuc.lan:8500/ui"
  }

  vault {
    ui_url = "http://nuc.lan:8200/ui"
  }
}