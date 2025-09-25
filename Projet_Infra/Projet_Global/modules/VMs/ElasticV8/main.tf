terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}




resource "esxi_guest" "DSI_serveur_Ubuntu" {
  guest_name     = "DSI_serveur_ubuntu"
  disk_store     = var.datastore
  ovf_source     = "${var.OVAs_Path}AlmaLinux9.5.ova"
  memsize        = 4096
  numvcpus       = 1
  boot_firmware  = "efi"
  power		 = "on"

#Interface 1 : Gestion admin
  network_interfaces {
    virtual_network = "GRP-RTR-FW"
    nic_type        = "e1000"
  }

#Interface 2 : Carte reseau
  network_interfaces {
    virtual_network = "DSI_serveurs"
    nic_type        = "e1000"
  }
}

