group "default" {
  targets = ["build", "build-wine"]
}

group "release-all" {
  targets = ["release",  "release-wine"]
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

target "build" {
  context = "."
  dockerfile = "Dockerfile"
  cache-from = ["type=registry,ref=ghcr.io/${REPO}"]
  cache-to = ["type=inline"]
  tags = tags("")
}

target "build-wine" {
  inherits = ["build"]
  args = { RELEASE = "wine" }
  tags = tags("-wine")
}

target "release" {
  inherits = ["build"]
  context = "."
  dockerfile = "Dockerfile"
  cache-from = ["type=gha"]
  cache-to = ["type=gha,mode=max"]
  attest = [
    "type=provenance,mode=max",
    "type=sbom"
  ]
  platforms = ["linux/amd64"]
  tags = tags("")
}

target "release-wine" {
  inherits = ["build-wine", "release"]
  tags = tags("-wine")
}
