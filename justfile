name := "bubylou/steamcmd"
tag := `git describe --tags --abbrev=0`

docker := "docker.io" / name + ":" + tag
github := "ghcr.io" / name + ":" + tag

cache := "--cache-from ghcr.io" / name + " --cache-to ghcr.io" / name
sbom := "--sbom syft --sbom-image-output ./sbom"

default: build-wine

build:
	buildah bud --build-arg RELEASE=default -t {{docker}} -t {{github}} .

build-wine: build
	buildah bud --build-arg RELEASE=wine -t {{docker}}-wine -t {{github}}-wine .

release: build
	buildah bud --build-arg RELEASE=default {{cache}} {{sbom}} -t {{docker}} -t {{github}} .

release-wine: build-wine
	buildah bud --build-arg RELEASE=wine {{cache}} {{sbom}} -t {{docker}}-wine -t {{github}}-wine .

release-all: release release-wine
