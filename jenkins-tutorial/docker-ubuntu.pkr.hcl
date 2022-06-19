packer {
  required_plugins {
    docker = {
      version = ">= 1.0.1"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:focal"
  commit = true
}

build {
  name    = "learn-packer"
  sources = [
    "source.docker.ubuntu"
  ]
}
