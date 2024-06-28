terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

data "docker_registry_image" "strapi" {
  name = "saniyashaikh/strapi-app:npm17"
}

# Reads the image metadata from a Docker Registry
resource "docker_image" "strapi" {
  name          = data.docker_registry_image.strapi.name
  pull_triggers = [data.docker_registry_image.ubuntu.sha256_digest]
}

# Create a container
resource "docker_container" "strapiapp" {
  image = docker_image.strapi.image_id
  name  = "strapiapp"
}