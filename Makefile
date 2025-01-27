APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=karpenkopd
VERSION=${shell git describe --tags --abbrev=0}-${shell git rev-parse --short HEAD}
TARGETARCH=arm64
TARGETOS=linux

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X='github.com/ospkiev/kbot/cmd.appVersion=${VERSION}';"

image:
	docker build --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS} -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

linux:
	GOOS=linux make build

darwin:
	GOOS=darwin make build

windows:
	GOOS=windows make build

arm:
	GOARCH=arm make build