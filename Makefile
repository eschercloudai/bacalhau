VERSION = 1.0.0

ifdef RELEASE
CONTROLLER_ARCH := amd64 arm64
BUILDX_OUTPUT := --push
else
CONTROLLER_ARCH := $(shell go env GOARCH)
BUILDX_OUTPUT := --load
endif

# Calculate the platform list to pass to docker buildx.
BUILDX_PLATFORMS := $(shell echo $(patsubst %,linux/%,$(CONTROLLER_ARCH)) | sed 's/ /,/g')

# This defines how docker containers are tagged.
DOCKER_ORG = ghcr.io/eschercloudai

.PHONY: all
all: images

.PHONY: images
images:
	if [ -n "$(RELEASE)" ]; then docker buildx create --name bacalhau --use; fi
	docker buildx build --build-arg VERSION=$(VERSION) --platform $(BUILDX_PLATFORMS) $(BUILDX_OUTPUT) -t ${DOCKER_ORG}/bacalhau:${VERSION} .
	if [ -n "$(RELEASE)" ]; then docker buildx rm bacalhau; fi
