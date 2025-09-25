terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}

provider "esxi" {
  esxi_hostname = "192.168.127.64"
  esxi_username = var.user
  esxi_password = var.passwd
}



module "RZO" {
  source = "./modules/Network"

  providers  = {
    esxi = esxi
  }
}



module "Vms" {
  source = "./modules/VMs"
  providers = {
    esxi = esxi
  }


  depends_on = [module.RZO]
}






















