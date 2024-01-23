FROM confluentinc/cp-kafka-connect:7.5.3

ENV CONNECT_PLUGIN_PATH: "/usr/share/java,/usr/share/confluent-hub-components"

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.6.3
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:14.0.12

USER root
RUN mkdir /app

COPY ./create-jks.sh /etc/kafka/secrets/create-jks.sh
RUN chmod +x /etc/kafka/secrets/create-jks.sh

COPY ./create-connectors.sh /app/create-connectors.sh
RUN chmod +x /app/create-connectors.sh

COPY ./entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]