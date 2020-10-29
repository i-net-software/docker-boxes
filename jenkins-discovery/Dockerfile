FROM alpine

VOLUME /etc/consul-template/templates
VOLUME /etc/consul-template/conf
VOLUME /etc/consul-template/output
VOLUME /etc/consul-template/scripts

COPY conf /etc/consul-template/conf
COPY templates /etc/consul-template/templates
COPY scripts /etc/consul-template/scripts

STOPSIGNAL SIGTERM

CMD tail -f /dev/null
