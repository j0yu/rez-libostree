#!/bin/bash
set -euf -o pipefail

# Perform the actual Python building and installing
# Ideally we're currently in an empty directory
INSTALL_DIR="${INSTALL_DIR:-$(mktemp -d)}"
VERSION="${VERSION:-2021.3}"
URL=https://github.com/ostreedev/ostree.git
mkdir -vp "$INSTALL_DIR"

export PATH="$REZ_GIT_ROOT"/bin:"$PATH"
echo "               git cloning: $URL"
echo "    into current directory: $(pwd)"
git clone --branch=v"$VERSION" "$URL" .

env NOCONFIGURE=1 ./autogen.sh
./configure --prefix="$INSTALL_DIR"
make
make install DEST="$INSTALL_DIR"
