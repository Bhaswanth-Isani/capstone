resource "google_service_account" "default" {
  account_id   = "capstone-sa"
  display_name = "Custom SA for Capstone Terraform"
}

resource "google_compute_network" "capstone-network" {
  name                    = "capstone-network"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "capstone" {
  name      = "capstone"
  network   = google_compute_network.capstone-network.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22", "5179", "5197"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["capstone"]
}

resource "google_compute_address" "ip_address" {
  name = "capstone-ip"
}

resource "google_compute_instance" "capstone-vm" {
  name         = "capstone-vm"
  machine_type = "e2-medium"
  zone         = "asia-south1-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.capstone-network.name

    access_config {
      nat_ip = google_compute_address.ip_address.address
    }
  }

  metadata_startup_script = file("initialize.sh")

  tags = google_compute_firewall.capstone.target_tags
}
