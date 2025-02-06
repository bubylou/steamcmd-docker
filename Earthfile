VERSION 0.8
FROM debian:12.9-slim
LABEL org.opencontainers.image.source="https://github.com/bubylou/steamcmd-docker"
LABEL org.opencontainers.image.authors="Nicholas Malcolm <bubylou@pm.me>"
LABEL org.opencontainers.image.licenses="MIT"
ARG --global --required tag

build:
    ENV USER=steam
    ENV GROUP=users
    ENV PUID=1000
    ENV PGID=100
    # Create inital user, group, and directories
    RUN mkdir /app /config /data \
        && groupmod -g ${PGID} ${GROUP} \
        && useradd -u ${PUID} -m ${USER} \
        && chown  ${USER}:${GROUP} -R /app /config /data

    ARG DEBIAN_FRONTEND=noninteractive
    RUN dpkg --add-architecture i386 \
        && sed -i "s/: main/: main non-free/" /etc/apt/sources.list.d/debian.sources \
        && apt-get update -y \
        # Insert SteamCMD agreement prompt answers
        && echo steam steam/question select "I AGREE" | debconf-set-selections \
        && echo steam steam/license note '' | debconf-set-selections \
        && apt-get install -y --no-install-recommends ca-certificates locales steamcmd \
        && ln -s /usr/games/steamcmd /usr/bin/steamcmd

    USER $USER

    # Update SteamCMD
    RUN steamcmd +quit \
        # Fix missing directories and libraries
        && mkdir -p $HOME/.steam \
        && ln -s $HOME/.local/share/Steam/steamcmd/linux32 $HOME/.steam/sdk32 \
        && ln -s $HOME/.local/share/Steam/steamcmd/linux64 $HOME/.steam/sdk64 \
        && ln -s $HOME/.steam/sdk32/steamclient.so $HOME/.steam/sdk32/steamservice.so \
        && ln -s $HOME/.steam/sdk64/steamclient.so $HOME/.steam/sdk64/steamservice.so

    ENTRYPOINT ["steamcmd"]
    CMD ["+help", "+quit"]

    SAVE IMAGE --push docker.io/bubylou/steamcmd:$tag docker.io/bubylou/steamcmd:latest
    SAVE IMAGE --push ghcr.io/bubylou/steamcmd:$tag ghcr.io/bubylou/steamcmd:latest

wine:
    FROM +build
    # Install Wine and xvfb for fake display
    USER root
    RUN apt-get install -y --no-install-recommends \
        wine wine32 wine64 libwine libwine:i386 wget \
        cabextract fonts-wine winbind xauth xvfb \
        # Install winetricks for configuring wine prefix and installing dependencies
        && wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
        && chmod +x winetricks \
        && mv -v winetricks /usr/local/bin
    USER $USER

    SAVE IMAGE --push docker.io/bubylou/steamcmd:$tag-wine docker.io/bubylou/steamcmd:latest-wine
    SAVE IMAGE --push ghcr.io/bubylou/steamcmd:$tag-wine ghcr.io/bubylou/steamcmd:latest-wine

all:
    BUILD +build
    BUILD +wine
