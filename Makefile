# APP=$(shell basename $(shell git remote get-url origin))
# REGISTRY=karpenkopd
# VERSION=${shell git describe --tags --abbrev=0}-${shell git rev-parse --short HEAD}
# TARGETARCH=arm64
# TARGETOS=linux

# format:
# 	gofmt -s -w ./
# lint:
# 	golint
# test:
# 	go test -v
# get:
# 	go get
# build: format get
# 	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/ospkiev/kbot/cmd.appVersion=${VERSION}
# image:
# 	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
# push:
# 	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
# clean:
# 	rm -rf kbot

APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=your_alternative_registry_here
VERSION=${shell git describe --tags --abbrev=0}-${shell git rev-parse --short HEAD}
TARGETARCH=amd64 arm64
TARGETOS=linux darwin windows

format:
    gofmt -s -w ./

lint:
    golint

test:
    go test -v

get:
    go get

build:
    $(foreach os, $(TARGETOS), \
        $(foreach arch, $(TARGETARCH), \
            CGO_ENABLED=0 GOOS=$(os) GOARCH=$(arch) go build -v -o $(APP)-$(os)-$(arch) -ldflags "-X='github.com/ospkiev/kbot/cmd.appVersion=$(VERSION)';" \
        ) \
    )

clean:
    rm -rf $(APP)-*

docker-build:
    docker build -t $(REGISTRY)/$(APP):$(VERSION) .

docker-push:
    docker push $(REGISTRY)/$(APP):$(VERSION)

linux:
    GOOS=linux make build

darwin:
    GOOS=darwin make build

windows:
    GOOS=windows make build

arm:
    GOARCH=arm make build