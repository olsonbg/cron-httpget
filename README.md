cron-httpget
=====

Periodically request data from a specified resource.

[![Build Status](https://travis-ci.com/olsonbg/cron-httpget.svg?branch=master)](https://travis-ci.com/olsonbg/cron-httpget "View build status")
[![](https://images.microbadger.com/badges/image/olsonbg/cron-httpget.svg)](https://hub.docker.com/r/olsonbg/cron-httpget "View on Docker Hub")
[![](https://images.microbadger.com/badges/version/olsonbg/cron-httpget.svg)](https://hub.docker.com/r/olsonbg/cron-httpget/tags "Show all tags on Docker hub")
[![](https://images.microbadger.com/badges/commit/olsonbg/cron-httpget.svg)](https://microbadger.com/images/olsonbg/cron-httpget "Get your own version badge on microbadger.com")

My specific use case is for calling a `cron.php` resource for a
[RedCAP](https://projectredcap.org "RedCAP Homepage") instance running
inside a [Kubernetes](https://kubernetes.io/ "Kubernetes Homepage")
container. I've been running this for the past 40+ days with no problems,
so I decided to clean it up and release this in the hopes that others would
find it useful.


# About

This is primarily intended to be used inside a container orchestration
environment, therefore all configuration is done through [environmental
variables](#environmental-variables). A [liveness
probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/)
is also supported with the `/health` path and the TCP network address
defined by [CRON_LISTEN](#cron_listen). All output is sent to `stdout` for
easy monitoring with Kubernetes tools.

Once I get my [helm
chart](https://docs.helm.sh/) cleaned up, I'll add a repository for it to
make deploying easy.

# Docker Non-Root User

By default, the docker container runs with a UID of 1002, and GID of 1003 (I
semi-randomly picked those numbers), but should run fine with any UID/GID
combination.

# Environmental Variables

## CRON_URL

_Required_.

The URL to be periodically called. Example:

```bash
CRON_URL="http://www.example.com:80/cron.php"
```

## CRON_SCHEDULE

_Required_.

CRON Expression that is accepted by
<https://godoc.org/github.com/robfig/cron>. To have an HTTP
GET call be made every minute, use:

```bash
CRON_SCHEDULE="@every 1m"
```

## CRON_ACCEPT

_Optional_.

HTTP GET accept header sent to [CRON_URL](#cron_url), the default is:

```bash
CRON_ACCEPT="*/*"
```

To request only JSON output, the following would be appropriate:

```bash
CRON_ACCEPT="application/json"
```

## CRON_TIMEOUT

_Optional_.

HTTP GET timeout, in milliseconds. Default:

```bash
CRON_TIMEOUT="5000"
```

## CRON_LISTEN

_Required_.

TCP network address to listen on for health check. The path is `/health`. To listen on localhost port 8000, use:

```bash
CRON_LISTEN="127.0.0.1:8000"
```

With this, a call to `http://127.0.0.1:8000/health` should return a HTTP
response status code of 200.


