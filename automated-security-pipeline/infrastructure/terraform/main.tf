terraform {
  required_version = ">= 1.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "app_network" {
  name = "devsecops-network"
}

resource "docker_image" "app_image" {
  name = "devsecops-app:latest"
  build {
    context = "../../"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "app_container" {
  name  = "devsecops-app"
  image = docker_image.app_image.image_id
  
  ports {
    internal = 5000
    external = 5000
  }
  
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  env = [
    "ENVIRONMENT=development"
  ]
}

output "application_url" {
  value = "http://localhost:5000"
}
