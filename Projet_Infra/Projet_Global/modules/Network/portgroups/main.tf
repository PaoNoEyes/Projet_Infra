terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}




module "portgroup_prod_clients" {
  source = "./portgroups2"

  
 }

module "portgroup_DSI_serveurs" {
  source = "./portgroups3"

  
}

module "portgroup_DSI_clients" {
  source = "./portgroups4"
  
}



module "portgroup_prod_serveurs" {
  source = "./portgroups1"

 

}

module "portgroup_fws" {
  source = "./portgroups6"

 

}

module "portgroup_dmz" {
  source = "./portgroups7"

 

}



