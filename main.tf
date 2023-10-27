terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "mongodb_document_size_limits_reached" {
  source    = "./modules/mongodb_document_size_limits_reached"

  providers = {
    shoreline = shoreline
  }
}