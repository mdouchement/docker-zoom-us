# References:
#   https://hub.docker.com/r/solarce/zoom-us
#   https://github.com/sameersbn/docker-skype
FROM debian:jessie
MAINTAINER mdouchement

ENV DEBIAN_FRONTEND noninteractive

# Enable i386 arch
RUN dpkg --add-architecture i386

# Refresh package lists
RUN apt-get update
RUN apt-get -qy dist-upgrade

# Dependencies for the client .deb
RUN apt-get install -qy curl sudo desktop-file-utils lib32z1 libx11-6:i386 libegl1-mesa:i386 \
  libglib2.0-0:i386 libgl1-mesa-glx:i386 libxrender1:i386 libxcomposite1:i386 libxslt1.1:i386 \
  libgstreamer0.10-0:i386 libgstreamer-plugins-base0.10-0:i386 libxi6:i386 libsm6:i386 \
  libfontconfig1:i386 qdbus-qt5:i386 libpulse0:i386 libsqlite3-0:i386 libxcb-shm0:i386 \
  libxcb-shape0:i386 libxcb-xfixes0:i386 libxcb-randr0:i386 libxcb-image0:i386 \
  libx11-6 libegl1-mesa libxcb-shm0 \
  libglib2.0-0 libgl1-mesa-glx libxrender1 libxcomposite1 libxslt1.1 \
  libgstreamer0.10-0 libgstreamer-plugins-base0.10-0 libxi6 libsm6 \
  libfontconfig1 libpulse0 libsqlite3-0 \
  libxcb-shape0 libxcb-xfixes0 libxcb-randr0 libxcb-image0


# Grab the client .deb
# Install the client .deb
# Cleanup
RUN curl -sSL https://www.zoom.us/client/latest/zoom_1.1.38634.0127_amd64.deb -o /tmp/zoom_setup.deb
RUN dpkg -i /tmp/zoom_setup.deb
RUN apt-get -f install
RUN rm /tmp/zoom_setup.deb \
  && rm -rf /var/lib/apt/lists/*

COPY scripts/ /var/cache/zoom-us/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
