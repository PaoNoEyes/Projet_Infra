terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}


resource "esxi_portgroup" "FWs" {
  name    = "GRP-FW-FW"
  vswitch = "vSW-FW-FW"
}
