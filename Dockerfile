FROM alpine:latest

ARG APPUSER_UID
ARG APPUSER_GID
ARG GIT_BRANCH=unspecified
ARG GIT_COMMIT=unspecified
ARG GIT_TAG=unspecified

LABEL cron-httpget.git.branch=$GIT_BRANCH
LABEL cron-httpget.git.commit=$GIT_COMMIT
LABEL cron-httpget.git.tag=$GIT_TAG

RUN apk update \
    && apk upgrade \
    && addgroup -g "$APPUSER_GID" appuser \
    && adduser -h /app -g "cron-httpget" -u "$APPUSER_UID" -s /sbin/nologin -G appuser -D appuser

WORKDIR /app

COPY cron-httpget /app/cron-httpget

# Run container as this user
USER appuser
CMD ["/app/cron-httpget"]
