ARG UBUNTU_RELEASE=24.04

FROM ubuntu:$UBUNTU_RELEASE AS builder-prep
COPY ./scripts /root/scripts
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt full-upgrade -y \
    && apt install -y sudo \
    && /root/scripts/requirements-install.sh \
    && /root/scripts/get-azahar-latest.sh
#    && apt-get clean -y #\
#    && rm -rf /var/lib/apt/lists/*

FROM builder-prep AS builder
RUN /root/scripts/compile-azahar.sh
#\
#    && find / -name azahr-room -type f \
#    && rm -rf /root/scripts

FROM ubuntu:$UBUNTU_RELEASE AS final
RUN apt update && DEBIAN_FRONTEND=noninteractive apt full-upgrade -y \
    && apt install libc++-dev -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /root/azahar-rooms/source/build/bin/Release/azahar-room /root/

ENTRYPOINT [ "/opt/azahar/exe/run.sh" ]
