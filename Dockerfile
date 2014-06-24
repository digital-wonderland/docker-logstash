# Logstash

FROM digitalwonderland/oracle-jre-8:latest

Add ./src /

RUN yum install -y logstash && yum clean all; \
    chmod +x /usr/local/sbin/start.sh; \
    mkdir /mnt/logstash-forwarder; \
    chown -R logstash:logstash /mnt/logstash-forwarder

EXPOSE 5043

VOLUME ["/etc/logstash", "/mnt/logstash-forwarder"]

USER logstash

ENTRYPOINT ["/usr/local/sbin/start.sh"]
