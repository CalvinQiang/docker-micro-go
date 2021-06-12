FROM alpine:3.8 as protoc_builder
RUN apk add --no-cache build-base curl automake autoconf libtool git zlib-dev

# 本镜像使用旧的micro, 已弃用consul
# 参考地址如下:
#
# https://micro.mu/blog/2019/10/04/deprecating-consul.html
RUN apk add --no-cache go
ENV GOPATH=/go \
        PATH=/go/bin/:$PATH

ENV GRPC_VERSION=1.16.0 \
        PROTOBUF_VERSION=3.6.1 \
        OUTDIR=/out

RUN go get -u -v -ldflags '-w -s' \
        go get github.com/micro/micro \
        && install -c ${GOPATH}/bin/micro ${OUTDIR}/usr/bin/

# 二次重构, 仅获取bin文件
FROM alpine:3.8
COPY --from=protoc_builder /out/ /

ENTRYPOINT []