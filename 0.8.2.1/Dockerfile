FROM ubuntu:14.04.2
MAINTAINER tobilg <fb.tools.github@gmail.com>

RUN apt-get update && apt-get install -yq --no-install-recommends --force-yes \
    curl \
    wget \
    openjdk-7-jre-headless

ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.10"

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

RUN wget -q http://www.eu.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"

RUN tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

ADD ./kafka-marathon-bootstrap.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/kafka-marathon-bootstrap.sh

RUN mkdir -p /var/log/kafka

VOLUME ["/var/log/kafka"]

ENTRYPOINT ["/usr/local/bin/kafka-marathon-bootstrap.sh"]