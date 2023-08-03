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

module "kubernetes_available_memory_for_requests_in_percentage_low" {
  source    = "./modules/kubernetes_available_memory_for_requests_in_percentage_low"

  providers = {
    shoreline = shoreline
  }
}