#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME=ghcr.io/0rax/boinc-client
BOINC_PKGVER="7.20.5+dfsg-1.1"
BOINC_VERSION="v${BOINC_PKGVER%+*}"

BUILD_CONFIG=(
    "amd64:linux/amd64:Dockerfile"
    "arm32v7:linux/arm/v7:Dockerfile"
    "arm64v8:linux/arm64:Dockerfile"
)

TAG_LATEST=()
TAG_VERSION=()

for config in "${BUILD_CONFIG[@]}"; do

    IFS=":" read -r -a cfg <<< "$config"
    architecture=${cfg[0]}
    platform=${cfg[1]}
    dockerfile=${cfg[2]}

    tag="${IMAGE_NAME}:${architecture}"
    tagv="${IMAGE_NAME}:${BOINC_VERSION}-${architecture}"

    TAG_LATEST+=("${tag}")
    TAG_VERSION+=("${tagv}")

    docker buildx build --platform "${platform}" \
        -t "${tag}" -t "${tagv}" --push \
        --build-arg "BUILDARCH=${architecture}" \
        --build-arg "BOINCPKGVER=${BOINC_PKGVER}" \
        --build-arg "BOINCVERSION=${BOINC_VERSION}" \
        -f "${dockerfile}" .

done

docker manifest create "ghcr.io/0rax/boinc-client:latest" "${TAG_LATEST[@]}"
docker manifest push --purge "ghcr.io/0rax/boinc-client:latest"

docker manifest create "ghcr.io/0rax/boinc-client:${BOINC_VERSION}" "${TAG_VERSION[@]}"
docker manifest push --purge "ghcr.io/0rax/boinc-client:${BOINC_VERSION}"
