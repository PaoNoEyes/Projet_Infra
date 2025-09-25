terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}



resource "esxi_guest" "serv_prod_win" {
  guest_name     = "serv_prod_win"
  disk_store     = var.datastore
  ovf_source     = "${var.OVAs_Path}ServProdWinLeVrai.ova"
  memsize        = 8192
  numvcpus       = 2	
  boot_firmware  = "efi"
  power		 = "on"



#Interface 1 : Gestion admin
  network_interfaces {
    virtual_network = "GRP-RTR-FW"
    nic_type        = "e1000"
  }

#Interface 2 : Carte reseau
  network_interfaces {
    virtual_network = "prod_serveurs"
    nic_type        = "e1000"
  }
}

