FROM ubuntu:16.04

COPY ./sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y nodejs-legacy