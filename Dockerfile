FROM ubuntu:jammy
#as base

ARG VERSION
ARG TARGETARCH

WORKDIR /usr/local/bin

RUN apt update \
 && apt -y install wget tar gzip jq \
 && wget -q https://github.com/bacalhau-project/bacalhau/releases/download/v${VERSION}/bacalhau_v${VERSION}_linux_${TARGETARCH}.tar.gz -O- | tar xz

#FROM scratch

#COPY --from=base /usr/local/bin/bacalhau /
#COPY --from=base /tmp /

# Cannot run as non-root :/
#COPY hack/passwd.nonroot /etc/passwd
#USER 1000

ENTRYPOINT ["/usr/local/bin/bacalhau"]
