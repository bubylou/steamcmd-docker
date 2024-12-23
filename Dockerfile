FROM debian:12.8-slim

ENV USER=steam
ENV PUID=1000

# Install SteamCMD from nonfree i386 repo
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
	&& sed -i "s/: main/: main non-free/" /etc/apt/sources.list.d/debian.sources \
	&& apt-get update -y \
	# Insert SteamCMD agreement prompt answers
	&& echo steam steam/question select "I AGREE" | debconf-set-selections \
	&& echo steam steam/license note '' | debconf-set-selections \
	&& apt-get install -y --no-install-recommends ca-certificates locales steamcmd \
	wget procps ncat

ARG RELEASE="default"
# Install Wine and xvfb for fake display
RUN if [ "$RELEASE" = "wine" ]; then apt-get install -y --no-install-recommends \
	wine wine32 wine64 libwine libwine:i386 cabextract fonts-wine winbind xauth xvfb \
	&& rm -rf /var/lib/apt/lists/*; fi

# Install winetricks for configuring wine
RUN if [ "$RELEASE" = "wine" ]; then wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
	&& chmod +x winetricks \
	&& mv -v winetricks /usr/local/bin; fi

# Add unicode support
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' \
	LANGUAGE='en_US:en'

# Create inital user and directories
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd \
	&& mkdir /app /config /data \
	&& useradd -u $PUID -m $USER \
	&& chown  $USER:$USER -R /app /config /data

USER steam

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
