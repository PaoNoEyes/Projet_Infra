terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}


resource "esxi_guest" "client_3_win" {
  guest_name     = "Client_Win3"
  disk_store     = var.datastore
  ovf_source     = "${var.OVAs_Path}Client_Win.ova"
  memsize        = 4096
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
    virtual_network = "prod_clients"
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
    command = "sleep 120 && ansible-playbook -i '${self.ip_address},' -u user -e 'ansible_password=resu ansible_connection=winrm ansible_winrm_transport=basic ansible_winrm_scheme=http ansible_port=5985 ansible_winrm_server_cert_validation=ignore ansible_shell_type=powershell' /home/user/Projet_Global/modules/VMs/ClientWin3/playbook.yml"
  }

}

