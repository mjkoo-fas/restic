FROM golang:1.16-alpine AS builder

WORKDIR /go/src/github.com/scm101/restic

# Caching dependencies
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go run build.go

FROM alpine:latest AS restic

RUN apk add --update --no-cache ca-certificates fuse openssh-client tzdata

ENV RESTIC_PASSWORD="fuzzpass"

RUN  /go/src/github.com/scm101/restic/restic init --repo /store

ENTRYPOINT ["/go/src/github.com/scm101/restic/restic", "backup", "-r", "/store", "--stdin"]
