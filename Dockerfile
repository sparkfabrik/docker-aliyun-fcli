FROM golang:1.10-alpine3.8 as build
ENV ALIYUNFCLI_VERSION 1.0.1
WORKDIR /go/src/github.com/aliyun
RUN apk add --no-cache curl git
RUN curl -Lo /go/src/github.com/aliyun/fcli.zip https://github.com/aliyun/fcli/archive/v${ALIYUNFCLI_VERSION}.zip && \
    unzip /go/src/github.com/aliyun/fcli.zip && \
    mv fcli-${ALIYUNFCLI_VERSION} fcli && \
    cd fcli && \
    go get github.com/Masterminds/glide && \
    go install github.com/Masterminds/glide && \
    glide i -v && \
    go build -v && \
    cp fcli /

FROM alpine:3.8
COPY --from=build /fcli /usr/local/bin/fcli
ENTRYPOINT [ "/usr/local/bin/fcli" ]
