# see https://github.com/seges/docker-nginx-consul
FROM nginx:1.14.0

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && \
    apt-get -y install wget runit unzip && \
    rm -rf /var/lib/apt/lists/*

# vim - debug purposes
ENV CONSUL_TEMPLATE_VERSION=0.25.1

RUN wget "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" \
    && unzip -d /usr/local/bin "consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" && rm "consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip"

ADD nginx.service /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run

RUN mkdir /etc/consul-template && chmod +x /etc/service/nginx/run && chmod +x /etc/service/consul-template/run

CMD ["/usr/bin/runsvdir", "/etc/service"]