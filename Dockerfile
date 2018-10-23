FROM alpine:latest

ARG APPUSER_UID=1002
ARG APPUSER_GID=1003
ARG GIT_BRANCH=unspecified
ARG GIT_COMMIT=unspecified
ARG GIT_TAG=unspecified

LABEL cron-httpget.git.branch=$GIT_BRANCH \
      cron-httpget.git.commit=$GIT_COMMIT \
      cron-httpget.git.tag=$GIT_TAG \
      org.label-schema.name="cron-httpget" \
      org.label-schema.description="Periodically request data from a specified resource" \
      org.label-schema.url="https://github.com/olsonbg/cron-httpget" \
      org.label-schema.vcs-ref=$GIT_COMMIT \
      org.label-schema.vcs-url="https://github.com/olsonbg/cron-httpget"

RUN apk update \
    && apk upgrade \
    && addgroup -g "$APPUSER_GID" appuser \
    && adduser -h /app -g "cron-httpget" -u "$APPUSER_UID" -s /sbin/nologin -G appuser -D appuser

COPY cron-httpget /app/cron-httpget

# Run container as this user
USER appuser
CMD ["/app/cron-httpget"]
