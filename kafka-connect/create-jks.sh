#!/bin/bash

# if directory certs exists and ther is no truststore.jks
if [ -d /certs/ ] && [ ! -f /home/kafka/truststore.jks ]; then
  echo "Preparing truststore for connectors"
  # Add each certificate to the trust store
  mkdir -p /home/kafka
  STORE=/home/kafka/truststore.jks
  declare -i INDEX=0
  for CRT in /certs/*/*.crt; do
    keytool -keystore $STORE -storepass "changeme" -alias $INDEX -noprompt -import -file $CRT -storetype JKS
    INDEX+=1
  done
  echo "Preparing truststore for connectors is complete"
  chown appuser:appuser /home/kafka/truststore.jks
fi