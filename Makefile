all:
	go build -o cron-httpget -v -ldflags="-s -w"

buildenv:
	docker run --rm -it \
		-v "$(PWD)":/go/src/myapp \
		-w /go/src/myapp \
		--user "$(shell id -u):$(shell id -u)" \
		-e GOOS=linux \
		-e CGO_ENABLED=0 \
		-e GOCACHE=/tmp \
		golang:1.17 bash

clean:
	rm -f cron-httpget
