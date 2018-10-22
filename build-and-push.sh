#!/bin/sh

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_COMMIT=$(git rev-parse --short HEAD)
GIT_ROOT=$(git rev-parse --show-toplevel)
GIT_TAG=$(git describe)

APPUSER_UID="1002"
APPUSER_GID="1003"

# Build the docker image
docker build \
	-t olsonbg/cron-httpget:"$GIT_TAG" \
	-f "$GIT_ROOT/Dockerfile" \
	--build-arg GIT_BRANCH="$GIT_BRANCH" \
	--build-arg GIT_COMMIT="$GIT_COMMIT" \
	--build-arg GIT_TAG="$GIT_TAG" \
	--build-arg APPUSER_UID="$APPUSER_UID" \
	--build-arg APPUSER_GID="$APPUSER_GID" \
	"$GIT_ROOT"

docker push olsonbg/cron-httpget:"$GIT_TAG"
