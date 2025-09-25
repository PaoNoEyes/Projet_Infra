terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}


#Creation de la VM
resource "esxi_guest" "serv_prod_linux" {
  guest_name     = "serv_prod_linux"
  disk_store     = var.datastore
  ovf_source     = "${var.OVAs_Path}AlmaLinux9.5.ova"
  memsize        = 2048
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
    virtual_network = "prod_serveurs"
    nic_type        = "e1000"
  }

#Provisionnement avec ansible
  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.ip_address},' -u user -e'ansible_password=resu' /home/user/Projet_Global/modules/VMs/ProdLinux/Ansible_ProdLinux.yml"
  }

}
