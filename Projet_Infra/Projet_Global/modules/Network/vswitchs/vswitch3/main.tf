terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}


resource "esxi_vswitch" "vswitch_DSI_serveurs" {
  name       = "DSI_serveurs"
}
