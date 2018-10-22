package main

// Install cron package with:
//
// go get github.com/robfig/cron
// or,
// go get -d -v ./...

import (
	"fmt"
	"strconv"
	"net/http"
	"io/ioutil"
	"os"
	"time"
	"github.com/robfig/cron"
)

var cronurl string
var MyTimeout int64
var httpgetaccept string

func main() {

	var ok bool

	cronurl, ok = os.LookupEnv("CRON_URL")
	if !ok {
		// Exit if the environmental variable is not defined.
		fmt.Fprintln(os.Stderr, "Environmental Variable CRON_URL not defined.");
		os.Exit(1)
	}

	schedule, ok := os.LookupEnv("CRON_SCHEDULE")
	if !ok {
		// Exit if the environmental variable is not defined.
		fmt.Fprintln(os.Stderr, "Environmental Variable CRON_SCHEDULE not defined.");
		os.Exit(1)
	}

	httpgetaccept, ok = os.LookupEnv("CRON_ACCEPT")
	if !ok {
		// fmt.Fprintln(os.Stderr, "Environmental Variable CRON_ACCEPT not defined.");
		httpgetaccept = "*/*"
	}

	var timeout_str string

	timeout_str, ok = os.LookupEnv("CRON_TIMEOUT")
	if !ok {
		// fmt.Fprintln(os.Stderr, "Environmental Variable CRON_TIMEOUT not defined.");
		MyTimeout = 5000
	} else {
		var err error
		MyTimeout, err = strconv.ParseInt(timeout_str, 10, 64)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Can not convert '%s' to int64.", timeout_str);
			os.Exit(1)
		}
	}


	listen, ok := os.LookupEnv("CRON_LISTEN")
	if !ok {
		// Exit if the environmental variable is not defined.
		fmt.Fprintln(os.Stderr, "Environmental Variable CRON_LISTEN not defined.");
		os.Exit(1)
	}

	fmt.Fprintf(os.Stdout, "URL: %s\n", cronurl)
	fmt.Fprintf(os.Stdout, "Schedule: %s\n", schedule)
	fmt.Fprintf(os.Stdout, "Listening on: %s\n", listen)
	fmt.Fprintf(os.Stdout, "HTTP GET timeout: %d ms\n", MyTimeout)
	fmt.Fprintf(os.Stdout, "HTTP GET accept header: %s\n", httpgetaccept);

	c := cron.New()
	if err := c.AddFunc(schedule, pollurlWrapper); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
	c.Start()

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(200)
		w.Write([]byte("ok"))
	})

	if err := http.ListenAndServe(listen, nil); err != nil {
		fmt.Fprintf(os.Stderr, "Could not start server: %s\n", err.Error())
		os.Exit(1)
	}

	// c.Run()
}

func pollurlWrapper() {
	if err := pollurl(cronurl, MyTimeout, httpgetaccept); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
	}
}

func pollurl(url string, timeout int64, accept string) error {

	// Set a timeout for the HTTP Get.
	client := http.Client{
		Timeout: time.Duration(time.Duration(timeout) * time.Millisecond),
	}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return err
	}

	req.Header.Set("Accept", accept)

	fmt.Fprintf(os.Stdout,"Requesting...\n")

	resp, err := client.Do(req);

	if err != nil {
		return err
	} else {
		defer resp.Body.Close()
		// fmt.Fprintf(os.Stdout, "StatusCode: %d %s\n", resp.StatusCode,http.StatusText(resp.StatusCode))
		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			return err
		} else {
			fmt.Fprintf(os.Stdout, "%s\n", body)
		}
	}

	return err
}
