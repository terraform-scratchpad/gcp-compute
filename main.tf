# manage state into cloud storage with versioning activated
terraform {
  backend "gcs" {
    bucket = "qb-worldcup"
    prefix = "/terraform.tfstate"
  }
}

# terraform google provider
provider "google" {
  version = "2.5.0"
  region = "${var.region}"
}

# get available zones
data "google_compute_zones" "available" {
  project = "${var.project}"
}


# compute instance with custom image
resource "google_compute_instance" "default" {
  name = "tf-worldcup-${count.index}"

  project = "${var.project}"

  zone = "${data.google_compute_zones.available.names[0]}"

  machine_type = "n1-standard-1"

  tags = []

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
