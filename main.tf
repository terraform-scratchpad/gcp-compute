# terraform google provider
provider "google" {
  version = "1.15.0"
  region = "${var.region}"
  credentials = "${file("../account.json")}"
}


# manage state into cloud storage with versioning activated
terraform {
  backend "gcs" {
    bucket = "qb-worldcup"
    path = "/terraform.tfstate"
    credentials = "${file("../account.json")}"
  }
}

# get available zones
data "google_compute_zones" "available" {}


# compute instance with custom image
resource "google_compute_instance" "default" {
  zone = "${data.google_compute_zones.available.names[0]}"
  name = "tf-worldcup"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "fra-bel"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}

output "instance_id" {
  value = "${google_compute_instance.default.self_link}"
}