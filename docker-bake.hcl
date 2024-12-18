group "default" {
  targets = ["main", "wine"]
}

variable "REGISTRY" {
  default = "ghcr.io"
}

variable "REPO" {
  default = "bubylou/steamcmd"
}

variable "TAG" {
  default = "v1.3.2"
}

function "tag" {
  params = [tag]
  result = "${REGISTRY}/${REPO}:${tag}"
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
  tags = [tag("latest"), tag("${TAG}")]
}

target "wine" {
  inherits = ["main"]
  args = {
    WINE_ENABLED = true
  }
  tags = [tag("latest-wine"), tag("${TAG}-wine")]
}
