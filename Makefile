VERSION=${shell git describe --tags -abbrev=0}-${shell git rev-parse --short HEAD}

format:
	gofmt -s -w ./
build: 
	go build -v -o bin/kbot -ldflags "-X=github.com/ospkiev/kbot/cmd.appVersion=-040d64f" ./cmd/kbot/main.go