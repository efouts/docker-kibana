FROM nginx

RUN apt-get update \
	&& apt-get install -y supervisor

ADD https://github.com/hashicorp/consul-template/releases/download/v0.6.5/consul-template_0.6.5_linux_amd64.tar.gz /tmp/consul-template.tar.gz
RUN tar zxf /tmp/consul-template.tar.gz && mv consul-template_0.6.5_linux_amd64/consul-template /bin && rm -r consul-template_0.6.5_linux_amd64 

ADD https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz /tmp/kibana.tar.gz
RUN tar zxf /tmp/kibana.tar.gz && mv kibana-3.1.2/* /usr/share/nginx/html && rm -r kibana-3.1.2

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD config.js.ctmpl /etc/consul-template/config.js.ctmpl

EXPOSE 80

ENV SERVICE_NAME kibana
ENV CONSUL consul.service.consul:8500

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
