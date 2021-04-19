############### Provider Start ######################

provider "google" {
 credentials = file(var.secret)
 region = var.region
}

############### Provider End ######################

############### Backend remote state Start ######################

terraform {
 backend "gcs" {
   bucket  = "pipe-terraform-state"
   prefix  = "pipe-state"
 }
}

############### Backend remote state End ######################
