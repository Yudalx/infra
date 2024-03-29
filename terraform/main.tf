provider "google" {
  project = var.project
  region  = var.region
}

module "app" {
  source          = "./modules/app"
  public_key_path = var.public_key_path
  app_disk_image  = var.app_disk_image
  private_key_path = var.private_key_path
}

module "db" {
  source          = "./modules/db"
  public_key_path = var.public_key_path
  db_disk_image   = var.db_disk_image
  private_key_path = var.private_key_path
}
//resource "google_compute_instance" "app" {
//  name         = "reddit-app"
//  machine_type = "g1-small"
//  zone         = "europe-west1-b"
//
//  # определение загрузочного диска
//  boot_disk {
//    initialize_params {
//      image = var.disk_image
//    }
//  }
//
//  metadata = {
//    sshKeys = "appuser:${file(var.public_key_path)}"
//  }
//
//  tags = ["reddit-app"]
//
//  # определение сетевого интерфейса
//  network_interface {
//    # сеть, к которой присоединить данный интерфейс
//    network = "default"
//
//    # использовать ephemeral IP для доступа из Интернет
//    access_config {
//      nat_ip = google_compute_address.app_ip.address
//    }
//  }
//
//  connection {
//    # доступ ssh для provisioner
//    host        = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
//    type        = "ssh"
//    user        = "appuser"
//    agent       = false
//    private_key = file(var.private_key_path)
//  }
//
//  provisioner "file" {
//    source      = "files/puma.service"
//    destination = "/tmp/puma.service"
//  }
//
//  provisioner "remote-exec" {
//    script = "files/deploy.sh"
//  }
//}
//resource "google_compute_firewall" "firewall_ssh" {
//  name    = "default-allow-ssh"
//  network = "default"
//  allow {
//    protocol = "tcp"
//    ports    = ["22"]
//  }
//  source_ranges = ["0.0.0.0/0"]
//}
//
//resource "google_compute_firewall" "firewall_puma" {
//  name = "allow-puma-default"
//  # Название сети, в которой действует правило
//  network = "default"
//  # Какой доступ разрешить
//  allow {
//    protocol = "tcp"
//    ports    = ["9292"]
//  }
//  # Каким адресам разрешаем доступ
//  source_ranges = ["0.0.0.0/0"]
//  # Правило применимо для инстансов с тегом …
//  target_tags = ["reddit-app"]
//}
//
//resource "google_compute_address" "app_ip" {
//  name = "reddit-app-ip"
//}