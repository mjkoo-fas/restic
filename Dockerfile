FROM golang:1.17.3-buster as go-target

WORKDIR /go/src/github.com/scm101/restic

# Caching dependencies
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go run build.go

ENV RESTIC_PASSWORD="fuzzpass"

RUN  /go/src/github.com/scm101/restic/restic init --repo /store

ENTRYPOINT ["/go/src/github.com/scm101/restic/restic", "backup", "-r", "/store", "--stdin"]
