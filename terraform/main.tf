provider "google" {
  project = "infra-256612"
  region  = "europe-west1"
}
resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "europe-west1-b"

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "reddit-base-1571673093"
    }
  }

  metadata = {
    sshKeys = "appuser:${file("~/.ssh/appuser.pub")}"
  }

  tags = ["reddit-app"]

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    host = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = file("~/.ssh/appuser")
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

