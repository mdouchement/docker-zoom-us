This project is fully inspired of [sameersbn](https://github.com/sameersbn) [Skype](https://github.com/sameersbn/docker-skype)'s containerization.

# mdouchement/zoom-us

# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image with [Zoom](http://www.zoom.us) for Linux with support for audio/video calls.

The image uses [X11](http://www.x.org) and [Pulseaudio](http://www.freedesktop.org/wiki/Software/PulseAudio/) unix domain sockets on the host to enable audio/video support in Zoom. These components are available out of the box on pretty much any modern linux distribution.

## Contributing

If you find this image useful here's how you can help:

- Send a pull request with your awesome features and bug fixes
- Help users resolve their [issues](../../issues?q=is%3Aopen+is%3Aissue).

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/mdouchement/zoom-us) and is the recommended method of installation.

```bash
docker pull mdouchement/zoom-us:latest
```

Alternatively you can build the image yourself.

```bash
docker build -t mdouchement/zoom-us github.com/mdouchement/docker-zoom-us
```

With the image locally available, install the wrapper scripts by running the following as root:

```bash
docker run -it --rm \
  --volume /usr/local/bin:/target \
  mdouchement/zoom-us:latest install
```

This will install a wrapper script to launch `zoom`.

> **Note**
>
> If Zoom is installed on the the host then the host binary is launched instead of starting a Docker container. To force the launch of Zoom in a container use the `zoom-us-wrapper` script. For example, `zoom-us-wrapper zoom` will launch Zoom inside a Docker container regardless of whether it is installed on the host or not.

## Web Browser / SSO

Add the following option in `~/.config/zoomus.conf`
```
embeddedBrowserForSSOLogin=false
```

Zoom will spawn Iceweasel (Firefox) included in this image and open SSO provider web page.

## How it works

The wrapper scripts volume mount the X11 and pulseaudio sockets in the launcher container. The X11 socket allows for the user interface display on the host, while the pulseaudio socket allows for the audio output to be rendered on the host.

When the image is launched the following directories are mounted as volumes

- `${HOME}/.zoom`
- `${HOME}/.config`
- `XDG_DOWNLOAD_DIR` or if it is missing `${HOME}/Downloads`

This makes sure that your profile details are stored on the host and files received via Zoom are available on your host in the appropriate download directory.


# Maintenance

## Upgrading

To upgrade to newer releases:

  1. Download the updated Docker image:

  ```bash
  docker pull mdouchement/zoom-us:latest
  ```

  2. Run `install` to make sure the host scripts are updated.

  ```bash
  docker run -it --rm \
    --volume /usr/local/bin:/target \
    mdouchement/zoom-us:latest install
  ```

## Uninstallation

```bash
docker run -it --rm \
  --volume /usr/local/bin:/target \
  mdouchement/zoom-us:latest uninstall
```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it zoomus bash
```
