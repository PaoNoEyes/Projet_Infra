terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}



module "vSwitch30" {
  source = "./vswitch1"

  providers = {
    esxi = esxi
  }
}

module "vSwitch31" {
  source = "./vswitch2"

  providers = {
    esxi = esxi
  }
}

module "vSwitch130" {
  source = "./vswitch3"

  providers = {
    esxi = esxi
  }
}

module "vSwitch131" {
  source = "./vswitch4"

  providers = {
    esxi = esxi
  }
}


module "vSwitch100" {
  source = "./vswitch6"

  providers = {
    esxi = esxi
  }
}


module "vSwitch80" {
  source = "./vswitch7"

  providers = {
    esxi = esxi
  }
}



