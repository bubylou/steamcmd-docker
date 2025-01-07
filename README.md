# SteamCMD-Docker

SteamCMD is a command-line version of the Steam Client. Its primary use is to install and update various dedicated servers available on Steam.
This container was made to be used as a base image for building out other game specific containers but can be used for any other tasks SteamCMD can perform.
An example of a container image built on top of this one is [Moria](https://github.com/bubylou/moria-docker) and [Palworld](https://github.com/bubylou/palworld-docker).

For more detailed information about using SteamCMD see the official [wiki](https://developer.valvesoftware.com/wiki/SteamCMD).

## Usage

### Pull latest image
```shell
docker pull bubylou/steamcmd:latest
```
### Download Garrysmod
```shell
docker run -it bubylou/steamcmd:latest +login anonymous +app_update 4020 +quit
```

## Building

### Build image
```shell
docker buildx bake
```


## Wine Build

Another container build is avilable which bundles in Wine and other tools for running Windows game servers. The tags end in '-wine' such as 'latest-wine' or 'v1.4.1-wine'.
