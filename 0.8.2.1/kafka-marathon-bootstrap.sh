#!/bin/bash

# Get the last Host IP octet
IFS=. read ip1 ip2 ip3 ip4 <<< "$HOST"

# Create unique broker.id as combination of last octet and the given Marathon Docker port
broker_id="${ip4}${PORT0}"

# Write custom-server.properties config file
echo "broker.id=${broker_id}" > $KAFKA_HOME/config/custom-server.properties
echo "host.name=${HOST}" >> $KAFKA_HOME/config/custom-server.properties
echo "port=${PORT0}" >> $KAFKA_HOME/config/custom-server.properties
echo "log.dir=/var/log/kafka/kafka-${broker_id}" >> $KAFKA_HOME/config/custom-server.properties
echo "zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT}" >> $KAFKA_HOME/config/custom-server.properties

export JMX_PORT="${PORT1}"

exec $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/custom-server.properties