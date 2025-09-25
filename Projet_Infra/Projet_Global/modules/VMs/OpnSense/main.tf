terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}

#Firewall OpnSense

resource "esxi_guest" "OpnSense" {
  guest_name     = "OpnSense"
  disk_store     = var.datastore
  ovf_source     = "${var.OVAs_Path}OpnSense.ova"
  memsize        = 2048
  numvcpus       = 1
  boot_firmware  = "bios"
  power          = "on"



#Interface 1 : WAN
  network_interfaces {
    virtual_network = "GRP-RTR-FW"
    nic_type        = "e1000"
  }

#Interface 2 : DMZ
  network_interfaces {
    virtual_network = "GRP-DMZ-FW"
    nic_type        = "e1000"
  }

#Interface 3 : PfSense
  network_interfaces {
    virtual_network = "GRP-FW-FW"
    nic_type        = "e1000"
  }


}
