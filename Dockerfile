# References:
#   https://hub.docker.com/r/solarce/zoom-us
#   https://github.com/sameersbn/docker-skype
FROM debian:bullseye-slim
MAINTAINER mdouchement

ENV DEBIAN_FRONTEND noninteractive

# Refresh package lists
RUN apt-get update && \
	apt-get -qy dist-upgrade && \
	# Dependencies for the client .deb
	apt-get install -qy --no-install-recommends curl ca-certificates \
		firefox-esr sudo desktop-file-utils lib32z1 \
		libx11-6 libegl1-mesa libxcb-shm0 \
		libglib2.0-0 libgl1-mesa-glx libxrender1 libxcomposite1 libxslt1.1 \
		libgstreamer1.0-0 libgstreamer-plugins-base1.0-0 libxi6 libsm6 \
		libfontconfig1 libpulse0 libsqlite3-0 \
		libxcb-shape0 libxcb-xfixes0 libxcb-randr0 libxcb-image0 \
		libxcb-keysyms1 libxcb-xtest0 ibus ibus-gtk \
		libxcb-xinerama0 libxkbcommon-x11-0 \
		libnss3 libxss1 xcompmgr pulseaudio && \
	 apt-get clean -y && \
	 apt-get autoremove -y && \
	 rm -rf /var/lib/apt/lists/*

ARG ZOOM_URL=https://zoom.us/client/latest/zoom_amd64.deb

# Grab the client .deb
# Install the client .deb
# Cleanup
RUN curl -sSL $ZOOM_URL -o /tmp/zoom_setup.deb && \
	dpkg -i /tmp/zoom_setup.deb && \
	apt-get -f install && \
		rm -rf /var/lib/apt/lists/* && \
	rm /tmp/zoom_setup.deb

COPY scripts/ /var/cache/zoom-us/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
