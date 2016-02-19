FROM ubuntu

VOLUME /etc/consul-template/templates
VOLUME /etc/consul-template/conf

COPY conf/* /etc/consul-template/conf/
COPY templates/* /etc/consul-template/templates/

STOPSIGNAL SIGTERM

CMD tail -f /dev/null
