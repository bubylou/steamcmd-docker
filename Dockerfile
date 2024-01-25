FROM debian:stable-slim

LABEL org.opencontainers.image.authors="Nicholas Malcolm"
LABEL org.opencontainers.image.source="https://github.com/bubylou/steamcmd-docker"

ENV USER steam
ENV PUID 1000

# Insert SteamCMD agreement prompt answers
RUN echo steam steam/question select "I AGREE" | debconf-set-selections && \
	echo steam steam/license note '' | debconf-set-selections

# Install SteamCMD from nonfree i386 repo
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 && \
	sed -i "s/: main/: main non-free/" /etc/apt/sources.list.d/debian.sources && \
	apt-get update -y && \
	apt-get install -y --no-install-recommends ca-certificates locales steamcmd && \
	rm -rf /var/lib/apt/lists/*

# Add unicode support
RUN locale-gen en_US.UTF-8
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'

# Create inital user and directories
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd && \
	mkdir /app /config /data && \
	useradd -u $PUID -m $USER && \
	chown  $USER:$USER -R /app /config /data

USER steam
# Update SteamCMD
RUN steamcmd +quit

# Fix missing directories and libraries
RUN mkdir -p $HOME/.steam \
	&& ln -s $HOME/.local/share/Steam/steamcmd/linux32 $HOME/.steam/sdk32 \
	&& ln -s $HOME/.local/share/Steam/steamcmd/linux64 $HOME/.steam/sdk64 \
	&& ln -s $HOME/.steam/sdk32/steamclient.so $HOME/.steam/sdk32/steamservice.so \
	&& ln -s $HOME/.steam/sdk64/steamclient.so $HOME/.steam/sdk64/steamservice.so

ENTRYPOINT ["steamcmd"]
CMD ["+help", "+quit"]
