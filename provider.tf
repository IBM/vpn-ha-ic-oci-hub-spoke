terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.73.0"
    }
    oci = {
      source = "hashicorp/oci"
      version = "6.20.0"
    }
  }
}

provider "oci" {
}

provider "ibm" {
}