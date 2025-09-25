terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}



#Serveur Web SFTP DMZ

resource "esxi_guest" "DMZ_WEB_SFTP" {
  guest_name     = "DMZ_WEB_SFTP"
  disk_store     = var.datastore
  ovf_source     = "/media/disk2/OVA/Debian.ova"
  memsize        = 2048
  numvcpus       = 2
  boot_firmware  = "bios"
  power          = "on"



#Interface 1 : GRP-RTR-FW
  network_interfaces {
    virtual_network = "GRP-RTR-FW"
    nic_type        = "e1000"
  }

#Interface 2 : DMZ
  network_interfaces {
    virtual_network = "GRP-DMZ-FW"
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
    command = "ansible-playbook --timeout 3600 -i '${self.ip_address},' -u user -e 'ipmgmt=${self.ip_address} ansible_password=resu' /home/user/Projet_Global/modules/VMs/DMZ/test-ansible.yml"
  }

}
