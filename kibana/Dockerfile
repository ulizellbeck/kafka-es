FROM docker.elastic.co/kibana/kibana:8.11.3

USER root

RUN apt-get update && \
    apt-get -y install jq && \
    rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER kibana

ENTRYPOINT [ "/entrypoint.sh" ]