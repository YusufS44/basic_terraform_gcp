terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.25.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "gcp-class-417400"
  region = "us-east1"
  zone = "us-east1-b"
}

resource "google_compute_network" "vpc_network" {
  name                    = "tf-vpc-rdt-chewy"
  auto_create_subnetworks = "false"  # Set to true to create a subnetwork automatically
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "terraform-subnetwork"
  ip_cidr_range = "10.190.1.0/24"
  region        = "us-east1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-medium"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnetwork.id

    access_config {
      // This line is necessary for the instance to have an external IP address
    }
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
