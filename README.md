# SteamCMD-Docker

SteamCMD is a command-line version of the Steam Client. Its primary use is to install and update various dedicated servers available on Steam.
This container is made to be used as a base image for building out other game specific containers but can be used for any other tasks SteamCMD can perform.
An example of a container image built on top of this one is [PalWorld](https://github.com/bubylou/palworld-docker).

For detailed information about using SteamCMD see the official [wiki](https://developer.valvesoftware.com/wiki/SteamCMD).

## Usage

### Pull latest image
```shell
docker pull bubylou/steamcmd:latest
```
### Download CSGO
```shell
docker run -it bubylou/steamcmd:latest +login anonymous +app_update 740 +quit
```
