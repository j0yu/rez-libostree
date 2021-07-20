name = "libostree"

__version__ = "2021.3"
version = __version__ + "+local.1.0.0"

variants = [["os-CentOS-7", "arch-x86_64"]]

relocatable = False

build_command = r"""
set -euf -o pipefail

cp "$REZ_BUILD_SOURCE_PATH"/Dockerfile "$REZ_BUILD_SOURCE_PATH"/entrypoint.sh .

IMAGE_ID_FILE="$(readlink -f DockerImageID)"
# In rez resolved version:
# - REZ_OS_MAJOR_VERSION = centos
# - REZ_OS_MINOR_VERSION = 7
docker build --rm \
    --build-arg CENTOS_MAJOR="$REZ_OS_MINOR_VERSION" \
    --iidfile "$IMAGE_ID_FILE" \
    "$REZ_BUILD_PATH"

[ -t 1 ] && CONTAINER_ARGS=("--tty") || CONTAINER_ARGS=()
CONTAINER_ARGS+=("--env" "INSTALL_DIR={install_dir}")
CONTAINER_ARGS+=("--env" "VERSION={version}")
CONTAINER_ARGS+=("$(cat $IMAGE_ID_FILE)")


if [ $REZ_BUILD_INSTALL -eq 1 ]
then
    CONTAINER_ID=$(docker create "{CONTAINER_ARGS}")
    docker start -ia "$CONTAINER_ID"
    docker cp "$CONTAINER_ID":"{install_dir}"/. "{install_dir}"/
    docker rm "$CONTAINER_ID"
fi
""".format(
    version=__version__,
    install_dir="${{REZ_BUILD_INSTALL_PATH:-/usr/local}}",
    CONTAINER_ARGS="${{CONTAINER_ARGS[@]}}",
)


def commands():
    import os.path

    env.PATH.append(os.path.join("{root}", "bin"))
    env.PKG_CONFIG_PATH.append(os.path.join("{root}", "lib"))
