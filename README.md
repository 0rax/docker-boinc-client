# ghcr.io/0rax/boinc-client

A lightweight and more up to date multi-arch image to run the BOINC client using Docker. It also includes some extra tools to debug any possible issue from within the image (such as `ping`, `dig` and `curl`).

This repository is based on some of the work done over at [BOINC/boinc-client-docker](https://github.com/BOINC/boinc-client-docker).

This Docker image currently support the following architectures: `amd64`, `arm32v7` & `arm64v8`.

**NOTE**: Though based on the official BOINC Cliemt image, this image does not contain the `boinccmd_swarm` wrapper as Docker Swarm does not seem to used much anymore.

## Running this image

If you have Docker running on any of the supported architecture, you should be able to run this image using the following command:

```sh
docker run --detach \
  --name boinc \
  --publish 127.0.0.1:31416:31416 \
  --volume /opt/boinc:/var/lib/boinc \
  -e BOINC_GUI_RPC_PASSWORD="mypassword" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc" \
  ghcr.io/0rax/boinc-client:latest
```

## Configuration

### BOINC Client

This image being largely inspired by the official [BOINC/boinc-client-docker](https://github.com/BOINC/boinc-client-docker) image, it can be configured in pretty much the same way using the following environment variables:

| Parameter                | Default     | Function                                                                                                                                                          |
| :----------------------- | :---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `BOINC_GUI_RPC_PASSWORD` | `boinc`     | The password what you need to use, when you connect to the BOINC client.                                                                                          |
| `BOINC_CMD_LINE_OPTIONS` | n/a         | Allow custom command line options to be passed to `/usr/bin/boinc`, adding `--allow_remote_gui_rpc` will allow all remote client to connect to your BOINC client. |
| `BOINC_REMOTE_HOST`      | `127.0.0.1` | (Optional) Replace the `IP` with your IP address. In this case you can connect to the client only from this IP.                                                   |
| `TZ`                     | `Etc/UTC`   | (Optional) Specify a time zone. The default is UTC +0.                                                                                                            |

### Data Persistence

To enable BOINC configuration and database persistence, you should also attach a volume to `/var/lib/boinc` on this container.

### Remote Access

To expose the RPC interface of the running BOINC CLIENT, you should expose port 31416 to the host you wish to control it with. A pretty good CLI client to do so is [`boinctui` available on SourceForge](https://sourceforge.net/projects/boinctui/).

## Available tags

| Image                                            | Tags                         | Architecture                  | Note                                   |
| :----------------------------------------------- | :--------------------------- | :---------------------------- | :------------------------------------- |
| [ghcr.io/0rax/boinc-client][tag:v7.24.1]         | `v7.24.1`, `latest`          | `amd64`, `arm32v7`, `arm64v8` | Multi arch image running BOINC v7.24.1 |
| [ghcr.io/0rax/boinc-client][tag:v7.24.1-amd64]   | `v7.24.1-amd64`, `amd64`     | `amd64`                       | `amd64` image running BOINC v7.24.1    |
| [ghcr.io/0rax/boinc-client][tag:v7.24.1-arm32v7] | `v7.24.1-arm32v7`, `arm32v7` | `arm32v7`                     | `arm32v7` image running BOINC v7.24.1  |
| [ghcr.io/0rax/boinc-client][tag:v7.24.1-arm64v8] | `v7.24.1-arm64v8`, `arm64v8` | `arm64v8`                     | `arm64v8` image running BOINC v7.24.1  |

[tag:v7.24.1]: https://github.com/0rax/docker-boinc-client/pkgs/container/boinc-client/348864248?tag=v7.24.1
[tag:v7.24.1-amd64]: https://github.com/0rax/docker-boinc-client/pkgs/container/boinc-client/348849343?tag=v7.24.1-amd64
[tag:v7.24.1-arm32v7]: https://github.com/0rax/docker-boinc-client/pkgs/container/boinc-client/348854748?tag=v7.24.1-arm32v7
[tag:v7.24.1-arm64v8]: https://github.com/0rax/docker-boinc-client/pkgs/container/boinc-client/348863715?tag=v7.24.1-arm64v8

A complete list of all current and past version can be seen in the [Github Packages page for this image](https://github.com/users/0rax/packages/container/package/boinc-client).

## Build

### Requirements

Building images for a "non-native" platform requires the activation of some experimental features in Docker. Mainly the use of `docker buildx`, `docker manifest` and QEMU's `binfmt` integration.

See https://docs.docker.com/buildx/working-with-buildx/ and https://the-empire.systems/cross-architecture-docker-images as a starting point for your setup.

What is important is that your current builder has an output similar to:

```txt
$ docker buildx inspect builder
Name:   builder
Driver: docker-container

Nodes:
Name:      builder0
Endpoint:  unix:///var/run/docker.sock
Status:    running
Platforms: linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
```

What's important here is that the `linux/amd64`, `linux/arm64` and `linux/arm/v7` platforms are listed.

If you are missing some platform out of the box, using [`tonistiigi/binfmt`](https://github.com/tonistiigi/binfmt) can be used to install the required emulators by running:

```sh
docker run --privileged --rm tonistiigi/binfmt --install arm,arm64
```

### Building an image

A script is available (see [`build.sh`](build.sh)) at the root of this repository to help release any new version of the image for all plateform, though if you want to build one image manually you can do so using one the following commands, depending on your target architecture.

#### `amd64`

```sh
docker buildx build --platform "linux/amd64" \
    -t boinc-client --build-arg "BUILDARCH=amd64" .
```

#### `arm32v7`

```sh
docker buildx build --platform "linux/arm/v7" \
    -t boinc-client --build-arg "BUILDARCH=arm32v7" .
```

#### `arm64v8`

```sh
docker buildx build --platform "linux/arm64" \
    -t boinc-client --build-arg "BUILDARCH=arm64v8" .
```

## License

docker-boinc-client is LGPLv3 licensed. See [LICENSE](LICENSE).
