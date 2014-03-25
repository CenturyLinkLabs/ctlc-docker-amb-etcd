FROM ubuntu:precise
MAINTAINER	lucas@rufy.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq -y && \
    apt-get install -qq -y socat && \
    apt-get clean

ADD https://github.com/coreos/etcd/releases/download/v0.3.0/etcd-v0.3.0-linux-amd64.tar.gz /etcd.tgz
ADD run.sh /run.sh

RUN tar xfz etcd.tgz
RUN mv etcd-*/etcdctl /usr/bin/
RUN rm -rf /etcd*
RUN chmod +x run.sh

CMD	/run.sh
