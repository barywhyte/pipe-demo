############### Provider Start ######################

provider "google" {
 credentials = file(var.secret)
 region = var.region
}

############### Provider End ######################
############### Backend Start ######################




terraform {
 backend "gcs" {
   bucket  = "pipe-terraform-state"
   prefix  = "pipe-state"
 }
}

############### Backend End ######################
