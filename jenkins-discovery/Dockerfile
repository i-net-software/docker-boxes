FROM alpine

VOLUME /etc/consul-template/templates
VOLUME /etc/consul-template/conf
VOLUME /etc/consul-template/output

COPY conf/* /etc/consul-template/conf/
COPY templates/* /etc/consul-template/templates/

STOPSIGNAL SIGTERM

CMD tail -f /dev/null
