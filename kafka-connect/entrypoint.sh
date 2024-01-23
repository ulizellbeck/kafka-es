#!/bin/bash
echo "Creating JKS files"
/etc/kafka/secrets/create-jks.sh
echo "Creating connectors"
/app/create-connectors.sh &
echo "Starting Kafka Connect worker"
/etc/confluent/docker/run