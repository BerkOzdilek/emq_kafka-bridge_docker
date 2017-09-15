FROM emq:base

RUN set -ex \
    && rm -rf /emqttd/deps/emq_kafka_bridge
    
ADD files/Makefile /emqttd
ADD files/relx.config /emqttd

# build the project
RUN set -ex \    
    && cd /emqttd \
    && make \
    && mkdir -p /opt && mv /emqttd/_rel/emqttd /opt/emqttd \
    && cd / && rm -rf /emqttd \
    && mv /start.sh /opt/emqttd/start.sh \
    && chmod +x /opt/emqttd/start.sh \
    && ln -s /opt/emqttd/bin/* /usr/local/bin/ \
    # removing fetch deps and build deps
    && apk --purge del .build-deps .fetch-deps \
    && rm -rf /var/cache/apk/*

# configure broker
# ADD files/emq_auth_redis.conf /opt/emqttd/etc/plugins
ENV EMQ_LOADED_PLUGINS=emq_kafka_bridge,emq_recon,emq_modules,emq_retainer,emq_dashboard
# ENV EMQ_MQTT__ALLOW_ANONYMOUS=false
# ENV EMQ_MQTT__ACL_NOMATCH=deny

WORKDIR /opt/emqttd

# start emqttd and initial environments
CMD ["/opt/emqttd/start.sh"]

RUN adduser -D -u 1000 emqtt

RUN chgrp -Rf root /opt/emqttd && chmod -Rf g+w /opt/emqttd \
      && chown -Rf emqtt /opt/emqttd

USER emqtt

VOLUME ["/opt/emqttd/log", "/opt/emqttd/data", "/opt/emqttd/lib", "/opt/emqttd/etc"]

# emqttd will occupy these port:
# - 1883 port for MQTT
# - 8883 port for MQTT(SSL)
# - 8083 for WebSocket/HTTP
# - 8084 for WSS/HTTPS
# - 8080 for mgmt API
# - 18083 for dashboard
# - 4369 for port mapping
# - 6000-6999 for distributed node
EXPOSE 1883 8883 8083 8084 8080 18083 4369 6000-6999
