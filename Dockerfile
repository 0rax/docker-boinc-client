# Ubuntu 24.10
ARG BUILDARCH=amd64
FROM $BUILDARCH/ubuntu:24.10

# Build arguments
ARG BUILDARCH
ARG BOINCPKGVER=8.0.4+dfsg-1
ARG BOINCVERSION=v8.0.4

# OCI labels
LABEL org.opencontainers.image.title="BOINC client for $BUILDARCH"
LABEL org.opencontainers.image.description="A lightweight BOINC client on $BUILDARCH."
LABEL org.opencontainers.image.url="https://github.com/0rax/docker-boinc-client"
LABEL org.opencontainers.image.source="https://github.com/0rax/docker-boinc-client"
LABEL org.opencontainers.image.authors="https://github.com/0rax/docker-boinc-client/graphs/contributors"
LABEL org.opencontainers.image.version="$BOINCVERSION-$BUILDARCH"

# Global environment settings
ENV BOINC_GUI_RPC_PASSWORD="boinc"
ENV BOINC_REMOTE_HOST="127.0.0.1"
ENV BOINC_CMD_LINE_OPTIONS=""
ENV DEBIAN_FRONTEND=noninteractive

# Install boinc and other extra utilities
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        tzdata curl wget iputils-ping dnsutils "boinc-client=$BOINCPKGVER" \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# Add custom entry-point
COPY rootfs/entrypoint.sh /entrypoint.sh

# Expose BOINC RPC port
EXPOSE 31416

# Set BOINC data folder as workdir and expose it as a volume for persistence
WORKDIR /var/lib/boinc
VOLUME /var/lib/boinc

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]
CMD []
