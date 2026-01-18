# Docker container for Krusader
[![Release](https://img.shields.io/github/release/jlesage/docker-krusader.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-krusader/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/krusader/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/krusader/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/krusader?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/krusader)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/krusader?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/krusader)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-krusader/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-krusader/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-krusader)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [Krusader](https://krusader.org).

The graphical user interface (GUI) of the application can be accessed through a
modern web browser, requiring no installation or configuration on the client

> This Docker container is entirely unofficial and not made by the creators of
> Krusader.

---

[![Krusader logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/krusader-icon.png&w=110)](https://krusader.org)[![Krusader](https://images.placeholders.dev/?width=256&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=Krusader&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://krusader.org)

Krusader is an advanced, twin-panel (commander-style) file manager for
Unix-like systems. It offers powerful file management features including archive
handling, access to local and remote filesystems, advanced search, directory
synchronization, file comparison, and batch renaming.

---

## Quick Start

**NOTE**:
    The Docker command provided in this quick start is an example, and parameters
    should be adjusted to suit your needs.

Launch the Krusader docker container with the following command:
```shell
docker run -d \
    --name=krusader \
    -p 5800:5800 \
    -v /docker/appdata/krusader:/config:rw \
    -v /home/user:/storage:rw \
    jlesage/krusader
```

Where:

  - `/docker/appdata/krusader`: Stores the application's configuration, state, logs, and any files requiring persistency.
  - `/home/user`: Contains files from the host that need to be accessible to the application.

Access the Krusader GUI by browsing to `http://your-host-ip:5800`.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-krusader.

## Support or Contact

Having troubles with the container or have questions? Please
[create a new issue](https://github.com/jlesage/docker-krusader/issues).

For other Dockerized applications, visit https://jlesage.github.io/docker-apps.
