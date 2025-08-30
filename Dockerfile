FROM alpine:3.22.1

# For access via VNC
EXPOSE 5900

# Expose Ports of RouterOS
EXPOSE 1194 1701 1723 1812/udp 1813/udp 21 22 23 443 4500/udp 50 500/udp 51 2021 2022 2023 2027 5900 80 8080 8291 8728 8729 8900

# Change work dir (it will also create this folder if not exist)
WORKDIR /routeros
RUN mkdir -p /routeros_source

# Install dependencies
RUN set -xe \
    && apk add --no-cache --update \
    netcat-openbsd qemu-x86_64 qemu-system-x86_64 \
    busybox-extras iproute2 iputils \
    bridge-utils iptables jq bash python3 wget

# Environment variables
ARG ROUTEROS_VERSION=7.19.4
ENV ROUTEROS_VERSION=${ROUTEROS_VERSION}
ENV ROUTEROS_IMAGE="mikrotik-${ROUTEROS_VERSION}.iso"
ENV ROUTEROS_PATH="https://github.com/elseif/MikroTikPatch/releases/download/${ROUTEROS_VERSION}/${ROUTEROS_IMAGE}"

# Download ISO image from GitHub
RUN wget "$ROUTEROS_PATH" -O "/routeros_source/${ROUTEROS_IMAGE}"

# Copy script to routeros folder
ADD ["./scripts", "/routeros_source"]

# Entrypoint script to boot RouterOS via QEMU
ENTRYPOINT ["/routeros_source/entrypoint.sh"]
