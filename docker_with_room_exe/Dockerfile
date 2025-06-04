# Setting some variables to be used during the build process of the image
ARG UBUNTU_RELEASE=24.04
ARG USR_ID=3000
ARG USR_NAME=azahar-user
ARG GRP_ID=3000
ARG GRP_NAME=azahar-group

# Stage to prepare the build environment
FROM ubuntu:$UBUNTU_RELEASE AS builder-prep
COPY ./scripts /root/scripts
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt full-upgrade -y \
    && apt install -y sudo \
    && /root/scripts/requirements-install.sh \
    && /root/scripts/get-azahar-latest.sh


# Stage to start the build of the executable
FROM builder-prep AS builder
RUN /root/scripts/compile-azahar.sh


# Stage to prepare the environment in wich the executable of the room will be running
FROM ubuntu:$UBUNTU_RELEASE AS final
ARG USR_ID
ARG USR_NAME
ARG GRP_ID
ARG GRP_NAME
RUN apt update && DEBIAN_FRONTEND=noninteractive apt full-upgrade -y \
    && apt install libc++-dev -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid $GRP_ID $GRP_NAME \
    && useradd -m -s /bin/bash --uid $USR_ID --gid $GRP_ID $USR_NAME

# Copy the executable from the builder stage into the final one
COPY --from=builder /root/azahar-rooms/source/build/bin/Release/azahar-room /app/

# Change the ownershop of the executable to the user azahar-runner.
# Uses the UID AND GID set in the variables at the beginning of the Dockerfile
RUN chown -R $USR_ID:$GRP_ID /app/azahar-room

# Switch to the user azahar-runner
USER $USR_NAME

ENTRYPOINT [ "/app/azahar-room" ]
