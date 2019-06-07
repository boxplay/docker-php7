FROM ubuntu:16.04

COPY ./sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget git

RUN cd / && wget -q https://npm.taobao.org/mirrors/node/v10.16.0/node-v10.16.0.tar.gz && tar -zxvf node-v10.16.0.tar.gz && cd node-v10.16.0.tar.gz && ./configure && make && make install
RUN node -v