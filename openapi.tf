#data "google_storage_bucket_object_content" "openapi_spec_doc" {
  #name   = "openapi-dev.yml"
  #bucket = "pipe-terraform-state"
#}

resource "google_endpoints_service" "openapi_service" {
  service_name   = var.service_name
  project        = var.project
  #openapi_config = data.google_storage_bucket_object_content.openapi_spec_doc.content
  openapi_config = file("./openapi.yaml")
}

