terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}




resource "esxi_guest" "PFSense" {
  guest_name     = "PfSense"
  disk_store     = var.datastore
  ovf_source     = "${var.OVAs_Path}PfSense.ova"
  memsize        = 2048
  numvcpus       = 1
  boot_firmware  = "bios"
  power 	 = "on"

#Interface 1 : OpnSense
  network_interfaces {
    virtual_network = "GRP-FW-FW"
    nic_type        = "e1000"
  }

#Interface 2 : vers_prod_serv
  network_interfaces {
    virtual_network = "prod_serveurs"
    nic_type        = "e1000"
  }


#Interface 3 : vers_prod_clients
  network_interfaces {
    virtual_network = "prod_clients"
    nic_type        = "e1000"
  }


#Interface 4 : vers_DSI_serv
  network_interfaces {
    virtual_network = "DSI_serveurs"
    nic_type        = "e1000"
  }


#Interface 5 : vers_DSI_clients
  network_interfaces {
    virtual_network = "DSI_clients"
    nic_type        = "e1000"
  }







}





