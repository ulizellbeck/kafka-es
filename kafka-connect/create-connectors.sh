#!/bin/bash
# If connect worker is running, then create connectors

echo "Creating connectors"

while [[ $response != 200 ]]; do
    echo "Creating connectors: Waiting for Kafka Connect worker..."
    sleep 5
    response="$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8083/connectors)"
    if [[ $response = 200 ]]; then
        echo "Creating connectors: Kafka Connect worker ready, starting imports"
        curl -i -X PUT http://localhost:8083/connectors/datagen_local_01/config \
            -H "Content-Type: application/json" \
            -d '{
                    "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
                    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
                    "kafka.topic": "pageviews",
                    "quickstart": "pageviews",
                    "max.interval": 1000,
                    "iterations": 10000000,
                    "tasks.max": "1"
                }'
        curl -i -X PUT http://localhost:8083/connectors/datagen_local_02/config \
            -H "Content-Type: application/json" \
            -d '{
                    "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
                    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
                    "kafka.topic": "syslog_logs",
                    "quickstart": "syslog_logs",
                    "max.interval": 1000,
                    "iterations": 10000000,
                    "tasks.max": "1"
                }'
        curl -X POST http://localhost:8083/connectors -H 'Content-Type: application/json' -d \
            '{
                "name": "elasticsearch-sink-logs",
                "config": {
                    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
                    "tasks.max": "1",
                    "topics": "syslog_logs",
                    "key.ignore": "true",
                    "schema.ignore": "true",
                    "connection.url": "https://es01:9200", 
                    "connection.username": "elastic",
                    "connection.password": "changeme",
                    "type.name": "_doc",
                    "name": "elasticsearch-sink-logs",
                    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
                    "value.converter.schemas.enable": "false",
                    "elastic.security.protocol":"SSL",
                    "elastic.https.ssl.truststore.location":"/home/kafka/truststore.jks",
                    "elastic.https.ssl.truststore.password":"changeme",
                    "elastic.https.ssl.truststore.type":"JKS",
                    "elastic.https.ssl.protocol":"TLS"
                }
                }'
        curl -X POST http://localhost:8083/connectors -H 'Content-Type: application/json' -d \
                '{
                "name": "elasticsearch-sink",
                "config": {
                    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
                    "tasks.max": "1",
                    "topics": "pageviews",
                    "key.ignore": "true",
                    "schema.ignore": "true",
                    "connection.url": "https://es01:9200", 
                    "connection.username": "elastic",
                    "connection.password": "changeme",
                    "type.name": "_doc",
                    "name": "elasticsearch-sink",
                    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
                    "value.converter.schemas.enable": "false",
                    "elastic.security.protocol":"SSL",
                    "elastic.https.ssl.truststore.location":"/home/kafka/truststore.jks",
                    "elastic.https.ssl.truststore.password":"changeme",
                    "elastic.https.ssl.truststore.type":"JKS",
                    "elastic.https.ssl.protocol":"TLS"
                }
                }'
        echo "Creating connectors: Done"
    fi
done