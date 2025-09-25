terraform {
  required_version = ">= 1.2.5"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
  }
}



module "Vswitchs" {
  source = "./vswitchs"

  providers  = {
    esxi = esxi
  }
}



module "GRPs" {
  source = "./portgroups"
  providers = {
    esxi = esxi
  }


  depends_on = [module.Vswitchs]
}


