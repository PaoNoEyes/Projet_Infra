terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}


resource "esxi_portgroup" "prod_serveurs" {
  name    = "prod_serveurs"
  vswitch = "Prod_serveurs"
}
