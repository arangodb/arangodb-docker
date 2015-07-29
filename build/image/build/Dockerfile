#this is a debian:latest bases image with additional software to build ArangoDB for a docker based image (v2.6+)
FROM debian:latest
MAINTAINER Heiko Kernbach <heiko@arangodb.com>

RUN apt-get -y update
RUN apt-get install -y apt-utils python curl libreadline6-dev git make autoconf automake libtool autotools-dev libssl-dev binutils
RUN apt-get install -y gcc g++ cpp libgoogle-perftools-dev

RUN curl -O https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.4.2.linux-amd64.tar.gz
RUN mkdir -p "$HOME/go"
