all:
	go get -d -v ./...
	CGO_ENABLED=0 go build -o cron-httpget -v -ldflags="-s -w"

clean:
	rm -f cron-httpget
