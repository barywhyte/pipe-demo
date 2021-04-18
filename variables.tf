######## Variables ###########

variable "project" {
  default =  "roava-io"
}

variable "secret" {
  type = string
  default     = "~/svc-accounts/pipe-demo.json"
  description = "default path to service account json file"
}


variable "service_account_email" {
  default = "pipe-demo@roava-io.iam.gserviceaccount.com"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "ssh_pub_key_file" {
  default = "~/.ssh/id_rsa.pub"
}

variable "region" {
  default = "us-central1"
}

variable "cluster_name" {
  default = "pipe-demo"
}

variable "cluster_zone" {
  default = "us-central1-a"
}

variable "network"{
  default = "pipe-demo"
}

variable "subnetwork"{
  default = "pipe-demo-subnet-1"
}

variable "subnetwork_range"{
  default = "192.168.0.0/20"
}

variable "cluster_secondary_name"{
  default = "pipe-demo-pods-1"
}

variable "cluster_service_name"{
  default = "pipe-demo-services-1"
}

variable "cluster_secondary_range"{
  default = "10.4.0.0/14"
}

variable "cluster_service_range"{
  default = "10.0.32.0/20"
}

variable "master_cidr"{
  default = "172.16.32.0/28"
}


variable "initial_node_count" {
  default = 1
}

variable "node_count" {
  default = 2
}

variable "autoscaling_min_node_count" {
  default = 1
}

variable "autoscaling_max_node_count" {
  default = 2
}

variable "disk_size_gb" {
  default = 50
}

variable "disk_type" {
  default = "pd-standard"
}

variable "machine_type" {
  default = "n1-standard-2"
}

######## Outputs ###########
###### Cluster endpoints ######
output "cluster_endpoint" {
  value = google_container_cluster.cluster.endpoint
}

###### Jumphost Compute instance ######
output "Bastion_host_instance_ip" {
  value = google_compute_instance.bastion-host.network_interface.0.access_config.0.nat_ip
}
