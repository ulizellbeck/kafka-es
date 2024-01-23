# Streaming Event Data and Logs with Kafka and Elasticsearch (secure)
This is a demo of how to stream data from Kafka topics into Elasticsearch and explore the data with Kibana.

## Prerequisites
- Docker
- Docker Compose

## How to use
1. Download the repository `git clone`
1. In your terminal navigate to the root of this folder and `docker-compose up -d`
1. Wait for the containers to start
1. Open Kibana at `localhost:5601` in your browser and login with the user `elastic` and the password `changeme`.
1. Go to the Discover tab and select the index `pageviews` and `syslog_logs` to explore the data.

## Details
This demo uses the following components:
- Kafka
- Zookeeper
- Elasticsearch
- Kibana
- Kafka Connect
- Kafka Connect Elasticsearch Sink Connector
- Kafka Connect Syslog Source Connector

 The Kafka Connect Syslog Source Connector is used to stream data from the syslog file into Kafka.
 The Kafka Connect Elasticsearch Sink Connector is used to stream data from Kafka topics into Elasticsearch.

### Customization

The `es-setup` container is used to generate the certificates for Elasticsearch. The certificates are generated with the [Elasticsearch certutil tool](https://www.elastic.co/guide/en/elasticsearch/reference/current/certutil.html).
It also generates the password for the `kibana_system` user.

Kibana is customized with the automatic loading of the data views for `pageviews` and `syslog_logs`.

The Kafka connect image is built from the Dockerfile in the `kafka-connect` folder. This image is based on the confluentinc/cp-kafka-connect image and adds the following plugins:
- [Kafka Connect Datagen Connector](https://docs.confluent.io/current/connect/kafka-connect-datagen/index.html)
- [Kafka Connect Elasticsearch Sink Connector](https://docs.confluent.io/current/connect/kafka-connect-elasticsearch/index.html)

The `create-jks.sh` script in the `kafka-connect` folder is used to create the Java truststore for the Elasticsearch Sink Connector. The truststore contains the certificates that have been generated from the `es-setup` container.
It is is generated with the [Java keytool](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html).
The `create-connectors.sh` script in the `kafka-connect` folder is used to create the connectors. It uses the [Kafka Connect REST API](https://docs.confluent.io/current/connect/references/restapi.html).

## References
- [Kafka docker compose](https://github.com/confluentinc/cp-all-in-one/blob/7.5.3-post/cp-all-in-one/docker-compose.yml)
- [Elasticsearch docker compose](https://github.com/elastic/elasticsearch/blob/8.12/docs/reference/setup/install/docker/docker-compose.yml)
- [Kafka Connect Elasticsearch Sink Connector](https://docs.confluent.io/current/connect/kafka-connect-elasticsearch/index.html)
- [Kafka Connect Syslog Source Connector](https://docs.confluent.io/current/connect/kafka-connect-syslog/index.html)

## License
[MIT](https://choosealicense.com/licenses/mit/)