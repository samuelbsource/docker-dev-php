packer {
  required_plugins {
    docker = {
      version = ">= 1.0.10"
      source = "github.com/hashicorp/docker"
    }
  }
}