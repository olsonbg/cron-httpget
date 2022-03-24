#!/bin/sh

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_COMMIT=$(git rev-parse --short HEAD)
GIT_ROOT=$(git rev-parse --show-toplevel)
GIT_TAG=$(git describe)

APPUSER_UID="1002"
APPUSER_GID="1003"

# Build app inside a golang docker image
docker run --rm \
	-v "$PWD":/usr/src/myapp \
	-w /usr/src/myapp \
	--user "$(id -u):$(id -g)" \
	-e GOOS=linux \
	-e CGO_ENABLED=0 \
	-e GOCACHE=/tmp \
	golang:1.17 make

# Build the docker image
docker build \
	-t cron-httpget:"$GIT_TAG" \
	-f "$GIT_ROOT/Dockerfile" \
	--build-arg GIT_BRANCH="$GIT_BRANCH" \
	--build-arg GIT_COMMIT="$GIT_COMMIT" \
	--build-arg GIT_TAG="$GIT_TAG" \
	--build-arg APPUSER_UID="$APPUSER_UID" \
	--build-arg APPUSER_GID="$APPUSER_GID" \
	"$GIT_ROOT"

echo "Test with: docker run -it cron-httpget:$GIT_TAG /bin/sh"
