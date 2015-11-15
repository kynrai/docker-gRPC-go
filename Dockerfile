FROM golang:latest

MAINTAINER "kynrai@gmail.com"

RUN apt-get update && apt-get install -y \
        unzip \
        libtool \
        autoconf \
        zlib1g-dev \
        make \
        cmake \
    && apt-get clean \

    # Install protobuf
    && wget https://github.com/google/protobuf/archive/v3.0.0-alpha-4.1.tar.gz \
    && tar xvzf v3.0.0-alpha-4.1.tar.gz \
    && cd protobuf-3.0.0-alpha-4.1 \
    && /go/protobuf-3.0.0-alpha-4.1/autogen.sh \
    && /go/protobuf-3.0.0-alpha-4.1/configure \
    && make -C /go/protobuf-3.0.0-alpha-4.1 \
    && make install -C /go/protobuf-3.0.0-alpha-4.1 \
    && cd /go \

    # Install grpc
    && git clone https://github.com/grpc/grpc /go/grpc \
    && cd /go/grpc \
    && git submodule update --init \
    && make -C /go/grpc \
    && make install -C /go/grpc \
    && make verify-install -C /go/grpc \

    # Install grpc-go
    && go get -u google.golang.org/grpc \

    # Install protoc-gen-go
    && go get -a github.com/golang/protobuf/protoc-gen-go \

    # Clean up
    && cd /go \
    && rm /go/v3.0.0-alpha-4.1.tar.gz \
    && rm -rf /go/protobuf-3.0.0-alpha-4.1 \
    && rm -rf /go/grpc \
ENTRYPOINT ["bash"]
WORKDIR $GOPATH
