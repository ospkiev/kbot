FROM golang:1.23 as builder
WORKDIR /go/src/app
COPY . .
ARG TARGETARCH
ARG TARGETOS
RUN GOARCH=${TARGETARCH} GOOS=${TARGETOS} make build
FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./kbot"]