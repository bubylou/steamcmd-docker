group "default" {
  targets = ["main", "wine"]
}

variable "REPO" {
  default = "bubylou/steamcmd"
}

variable "TAG" {
  default = "latest"
}

function "tags" {
  params = [suffix]
  result = ["ghcr.io/${REPO}:latest${suffix}", "ghcr.io/${REPO}:${TAG}${suffix}",
            "docker.io/${REPO}:latest${suffix}", "docker.io/${REPO}:${TAG}${suffix}"]
}

target "main" {
  context = "."
  dockerfile = "Dockerfile"
  cache-from = ["type=gha"]
  cache-to = ["type=gha,mode=max"]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/bubylou/steamcmd-docker"
    "org.opencontainers.image.authors" = "Nicholas Malcolm <bubylou@pm.me>"
    "org.opencontainers.image.licenses" = "MIT"
  }
  platforms = ["linux/amd64"]
  tags = tags("")
}

target "wine" {
  inherits = ["main"]
  args = {
    WINE_ENABLED = true
  }
  tags = tags("-wine")
}
