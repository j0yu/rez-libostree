#!/bin/bash
set -euf -o pipefail

# Perform the actual Python building and installing
# Ideally we're currently in an empty directory
INSTALL_DIR="${INSTALL_DIR:-$(mktemp -d)}"
VERSION="${VERSION:-2021.3}"
URL=https://github.com/ostreedev/ostree/releases/download/v"$VERSION"/libostree-"$VERSION".tar.xz
mkdir -vp "$INSTALL_DIR"

CURL_FLAGS=("-L")
[ -t 1 ] && CURL_FLAGS+=("-#") || CURL_FLAGS+=("-sS")

echo "Downloading and extracting: $URL"
echo "    into current directory: $(pwd)"
curl "${CURL_FLAGS[@]}" "$URL" | tar --strip-components=1 -xJ

env NOCONFIGURE=1 ./autogen.sh
./configure --prefix="$INSTALL_DIR"
make
make install DEST="$INSTALL_DIR"
