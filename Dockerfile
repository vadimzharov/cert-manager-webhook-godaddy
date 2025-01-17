FROM golang:1.14-alpine AS build_deps

RUN apk add --no-cache git

WORKDIR /usr/src
ENV GO111MODULE=on

COPY go.mod .
COPY go.sum .

RUN go mod download || true 
RUN go mod download || true 
RUN go mod download || true 
RUN go mod download || true 
RUN go mod download || true 
RUN go mod download || true
RUN go mod download 

FROM build_deps AS build

ARG IMAGE_ARCH=arm

ARG ARM_VERSION=7

ENV GOARCH=$IMAGE_ARCH

ENV GOARM=$ARM_VERSION

COPY . .

RUN CGO_ENABLED=0 go build -o webhook -ldflags '-w -extldflags "-static"' .

FROM alpine:3.9

RUN apk add --no-cache ca-certificates

COPY --from=build /usr/src/webhook /usr/local/bin/webhook

ENTRYPOINT ["webhook"]
