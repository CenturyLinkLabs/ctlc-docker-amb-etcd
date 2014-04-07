FROM ctlc/ambassador
MAINTAINER	lucas@rufy.com

ADD https://github.com/coreos/etcd/releases/download/v0.3.0/etcd-v0.3.0-linux-amd64.tar.gz /etcd.tgz
RUN tar xfz etcd.tgz
RUN mv etcd-*/etcdctl /usr/bin/
RUN rm -rf /etcd*

ADD /start-etcd-service-registry.sh /start-etcd-service-registry.sh
ADD /supervisord-etcd-service-registry.conf /etc/supervisor/conf.d/supervisord-etcd-service-registry.conf
RUN chmod 755 /*.sh

CMD ["/run.sh"]
