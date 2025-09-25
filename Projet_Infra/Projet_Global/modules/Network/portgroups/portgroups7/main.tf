terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}


resource "esxi_portgroup" "grp_DMZ_fw" {
  name    = "GRP-DMZ-FW"
  vswitch = "vSW-DMZ-FW"
}
