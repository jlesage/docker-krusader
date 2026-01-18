#
# krusader Dockerfile
#
# https://github.com/jlesage/docker-krusader
#

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.23-v4.10.6

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG KRUSADER_VERSION=2.9.0-r0

# Define working directory.
WORKDIR /tmp

# Install Krusader.
RUN \
    add-pkg krusader=${KRUSADER_VERSION} && \
    # Increase stack size of Krusader to fix crash seen when performing a
    # folder synchronzation.
    # See https://gitlab.alpinelinux.org/alpine/aports/-/issues/17906
    add-pkg --virtual build-dependencies git go && \
    git clone https://github.com/yaegashi/muslstack.git /tmp/muslstack && \
    cd /tmp/muslstack && \
    GOCACHE=/tmp/gocache go build main.go && \
    mv main muslstack && \
    ./muslstack -s 0x800000 /usr/bin/krusader && \
    # Cleanup.
    del-pkg build-dependencies && \
    rm -rf /root/.config && \
    rm -rf /tmp/* /tmp/.[!.]*

# Install extra packages.
RUN \
    add-pkg \
        # General tools.
        findutils-locate \
        kate \
        konsole \
        kdiff3 \
        kget \
        krename \
        # Checksum utilities.
        coreutils \
        # Packers.
        7zip \
        dpkg \
        lha \
        rpm \
        unarj \
        xz \
        zip \
        # For network connections.
        kio-extras \
        # A font is needed.
        font-dejavu \
        # For dark mode.
        adwaita-qt \
        && \
    true

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/krusader-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Krusader" && \
    set-cont-env APP_VERSION "$KRUSADER_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Define mountable directories.
VOLUME ["/storage"]

# Metadata.
LABEL \
      org.label-schema.name="krusader" \
      org.label-schema.description="Docker container for Krusader" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-krusader" \
      org.label-schema.schema-version="1.0"
