all:
	go get -d -v ./...
	go build -o cron-httpget -v -ldflags="-s -w"

clean:
	rm -f cron-httpget
