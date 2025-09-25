terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}




resource "esxi_guest" "client_1_linux" {
  guest_name     = "client_1_linux"
  disk_store     = var.datastore
  ovf_source     = "${var.OVAs_Path}Ubuntu22.04.ova"
  memsize        = 4096
  numvcpus       = 1
  boot_firmware  = "efi"
  power 	 = "on"



#Interface 1 : Gestion admin
  network_interfaces {
    virtual_network = "GRP-RTR-FW"
    nic_type        = "e1000"
  }

#Interface 2 : Carte reseau
  network_interfaces {
    virtual_network = "DSI_clients"
    nic_type        = "e1000"
  }

connection {
    host = self.ip_address
    type = "ssh"
    user = "user"
    password = "resu"
    timeout = "120s"
  }

provisioner "local-exec" {
    command = "ansible-playbook --timeout 3600 -i '${self.ip_address},' -u user -e 'ansible_password=resu' /home/user/Projet_Global/modules/VMs/Linux1/Ansible_Linux_Clients1.yml -vv"
  }
}

