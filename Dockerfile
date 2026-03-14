#
# krusader Dockerfile
#
# https://github.com/jlesage/docker-krusader
#

# Define software versions.
ARG KRUSADER_VERSION=2.9.0-r0
ARG UNRAR_VERSION=7.2.3

# Define software download URLs.
ARG UNRAR_URL=https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz

# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# Build unrar. It has been moved to non-free since Alpine 3.15.
# https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.15.0#unrar_moved_to_non-free
FROM --platform=$BUILDPLATFORM alpine:3.23 AS unrar
ARG TARGETPLATFORM
ARG UNRAR_URL
COPY --from=xx / /
COPY src/unrar /build
RUN /build/build.sh "$UNRAR_URL"
RUN xx-verify \
    /tmp/unrar-install/usr/bin/unrar

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.23-v4.11.3

ARG KRUSADER_VERSION
ARG DOCKER_IMAGE_VERSION

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

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
        # Breeze icons theme.
        breeze-icons \
        && \
    # Platform theme integration plugin.
    add-pkg --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing qt6ct && \
    # Disable kglobalaccel service: not needed and it has been seen consuming a
    # fair amount of CPU.
    rm /usr/share/dbus-1/services/org.kde.kglobalaccel.service && \
    true

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/krusader-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=unrar /tmp/unrar-install/usr/bin/unrar /usr/bin/unrar

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
