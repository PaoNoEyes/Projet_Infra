terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}



######################################################################################################

//FIREWALLS

######################################################################################################



module "opnsense" {
  source = "./OpnSense"
}


module "pfsense" {
  source = "./PFSense"

  depends_on = [module.opnsense]
}



######################################################################################################

//SERVEURS ZONE DMZ

######################################################################################################



module "dmz" {
  source = "./DMZ"

  depends_on = [module.pfsense]
}



######################################################################################################

//SERVEURS ZONE PROD

######################################################################################################



module "prodlinux" {
  source = "./ProdLinux"

  depends_on = [module.dmz]
}


module "prodwin" {
  source = "./ProdWin"

  depends_on = [module.prodlinux]
}



######################################################################################################

//CLIENTS ZONE DSI

######################################################################################################



module "clientlinux1" {
  source = "./Linux1"

  depends_on = []
}


module "clientlinux2" {
  source = "./Linux2"

  depends_on = []
}

module "clientlinux3" {
  source = "./Linux3"

  depends_on = [module.clientlinux2]
}



######################################################################################################

//CLIENTS ZONE PROD

######################################################################################################



module "clientwin1" {
  source = "./ClientWin1"

  depends_on = []
}


module "clientwin2" {
  source = "./ClientWin2"

  depends_on = [module.clientwin1]
}


module "clientwin3" {
  source = "./ClientWin3"

  depends_on = [module.clientwin2]
}



######################################################################################################

//SERVEURS ZONE DSI

######################################################################################################



module "dsiserveurwin" {
  source = "./WEC"

  depends_on = [module.clientwin3]
}


module "dsiserverlinux" {
  source = "./ElasticV8"

  depends_on = [module.dsiserveurwin]
}
