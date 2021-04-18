data "google_compute_zones" "available" {
  project = var.project
}

### Creating jump-host / bastion-host  ###
resource "google_compute_instance" "bastion-host" {
  name         = "bastion-host"
  project      = var.project
  machine_type = "n1-standard-1"
  zone         = data.google_compute_zones.available.names[0]
  tags         = ["ssh"]

  service_account {
    email = var.service_account_email
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network      = google_compute_network.vpc_net.self_link
    subnetwork   = google_compute_subnetwork.vpc_subnet.self_link
    access_config {}
  }

  metadata = {
    ssh-keys        = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
    startup-script  = file("./startup-script.sh")
    } 


  ## Copying startup script
  provisioner "file" {
    source = "./startup-script.sh"
    destination = "/tmp/startup-script.sh"
  }
    connection {
             type = "ssh"
             user = "ubuntu"
             host = google_compute_instance.bastion-host.network_interface.0.access_config.0.nat_ip
             private_key = file("~/.ssh/id_rsa")
             timeout = "1m"
             agent = "false"
     }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/startup-script.sh",
      "sudo bash /tmp/startup-script.sh ",
             ]

    connection {
             type = "ssh"
             user = "ubuntu"
             host = google_compute_instance.bastion-host.network_interface.0.access_config.0.nat_ip
             private_key = file("~/.ssh/id_rsa")
             timeout = "1m"
             agent = "false"
     }
     }

## Copying files for k8s pod and service sample app
  provisioner "file" {
    source = "./sampleapp"
    destination = "/tmp"

    connection {
             type = "ssh"
             user = "ubuntu"
             host = google_compute_instance.bastion-host.network_interface.0.access_config.0.nat_ip
             private_key = file("~/.ssh/id_rsa")
             timeout = "3m"
             agent = "false"
    }
  }    

  depends_on = [google_container_node_pool.nodepool0]
}