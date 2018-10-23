cron-httpget
=====

Periodically request data from a specified resource.

[![Build Status](https://travis-ci.com/olsonbg/cron-httpget.svg?branch=master)](https://travis-ci.com/olsonbg/cron-httpget)
[![](https://images.microbadger.com/badges/image/olsonbg/cron-httpget.svg)](https://microbadger.com/images/olsonbg/cron-httpget "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/olsonbg/cron-httpget.svg)](https://microbadger.com/images/olsonbg/cron-httpget "Get your own version badge on microbadger.com")

My specific use case is for calling a `cron.php` resource for a
[RedCAP](https://projectredcap.org "RedCAP Homepage")
instance running inside a [Kubernetes](https://kubernetes.io/ "Kubernetes
Homepage") container.


# About

This is primarily intended to be used inside a container orchestration
environment, therefore all configuration is done through [environmental
variables](#environmental-variables). A [liveness
probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/) is also supported
with the _/health_ path and the TCP network address define by
[CRON_LISTEN](#cron_listen).

# Docker Non-Root User

By default, the docker container runs with a UID of 1002, and GID of 1003 (I
semi-randomly picked those numbers), but should run find with any UID/GID
combination.

# Environmental Variables

## CRON_URL

Required.

The URL to be periodically called. Example:

```bash
CRON_URL="http://www.example.com:80/cron.php"
```

## CRON_SCHEDULE

Required.

CRON Expression that is accepted by
<https://godoc.org/github.com/robfig/cron>. To have an HTTP
GET call be made every minute, use:

```bash
CRON_SCHEDULE="@every 1m"
```

## CRON_ACCEPT

Optional.

HTTP GET accept header sent to [CRON_URL](#cron_url), the default is:

```bash
CRON_ACCEPT="*/*"
```

To request only JSON output, the following would be appropriate:

```bash
CRON_ACCEPT="application/json"
```

## CRON_TIMEOUT

Optional.

HTTP GET timeout, in milliseconds. Default:

```bash
CRON_TIMEOUT="5000"
```

## CRON_LISTEN

Required.

TCP network address to listen on for health check. The path is _/health_. To listen on localhost port 8000, use:

```bash
CRON_LISTEN="127.0.0.1:8000"
```

With this, a call to `http://127.0.0.1:8000/health` should return a HTTP
response status code of 200.


