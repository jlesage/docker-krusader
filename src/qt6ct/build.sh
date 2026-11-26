#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Set same default compilation flags as abuild.
export CFLAGS="-Os -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-Wl,--strip-all -Wl,--as-needed"

export CC=xx-clang
export CXX=xx-clang++

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

log() {
    echo ">>> $*"
}

QT6CT_URL="$1"

if [ -z "$QT6CT_URL" ]; then
    log "ERROR: qt6ct URL missing."
    exit 1
fi

#
# Install required packages.
#
apk --no-cache add \
    curl \
    patch \
    binutils \
    clang \
    make \
    cmake \
    pkgconf \
    qt6-qtbase-dev \

xx-apk --no-cache --no-scripts add \
    musl-dev \
    gcc \
    g++ \
    qt6-qtbase-dev \
    qt6-qtbase-private-dev \

# Make sure tools used to generate code are the ones from the host.
if xx-info is-cross; then
    for bin in moc uic rcc lrelease; do
        ln -sf /usr/lib/qt6/libexec/$bin $(xx-info sysroot)usr/lib/qt6/libexec/$bin
    done
    for bin in qtpaths; do
        ln -sf /usr/lib/qt6/bin/$bin $(xx-info sysroot)usr/lib/qt6/bin/$bin
    done
fi

#
# Download sources.
#

log "Downloading qt6ct package..."
mkdir /tmp/qt6ct
curl -# -L -f ${QT6CT_URL} | tar xz --strip 1 -C /tmp/qt6ct

#
# Compile qt6ct
#

log "Configuring qt6ct..."
(
    mkdir /tmp/qt6ct/build && \
    cd /tmp/qt6ct/build && \
    # shared-mime-info.pc is installed under /usr/share/pkgconfig.
    PKG_CONFIG_PATH=/$(xx-info)/usr/share/pkgconfig cmake \
        $(xx-clang --print-cmake-defines) \
        -DCMAKE_FIND_ROOT_PATH=$(xx-info sysroot) \
        -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
        -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
        -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY \
        -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        ..
)

log "Compiling qt6ct..."
make -C /tmp/qt6ct/build -j$(nproc)

log "Installing qt6ct..."
DESTDIR=/tmp/qt6ct-install make -C /tmp/qt6ct/build install
