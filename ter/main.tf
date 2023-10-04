terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

resource "yandex_compute_instance" "clickhouse" {
  name        = "clickhouse-01"
  platform_id = var.vms_zone
  
  resources {
    cores         = var.vms_resources.clickhouse.cores
    memory        = var.vms_resources.clickhouse.memory
    core_fraction = var.vms_resources.clickhouse.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-7.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = local.metadata
}

resource "yandex_compute_instance" "vector" {
  name        = "vector-01"
  platform_id = var.vms_zone
  
  resources {
   cores         = var.vms_resources.vector.cores
   memory        = var.vms_resources.vector.memory
   core_fraction = var.vms_resources.vector.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-7.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = local.metadata
}

resource "yandex_compute_instance" "lighthouse" {
  name        = "lighthouse-01"
  platform_id = var.vms_zone
  
  resources {
   cores         = var.vms_resources.lighthouse.cores
   memory        = var.vms_resources.lighthouse.memory
   core_fraction = var.vms_resources.lighthouse.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos-7.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = local.metadata
}
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
data "yandex_compute_image" "centos-7" {
  family = var.vms_family
}

resource "local_file" "hosts_cfg" {
  content = templatefile("./hosts.tftpl",
    {
      clickhouse = ["${yandex_compute_instance.clickhouse}"],
      vector     = ["${yandex_compute_instance.vector}"],
      lighthouse = ["${yandex_compute_instance.lighthouse}"]
    }
    )
  filename = "../playbook/inventory/prod"
}