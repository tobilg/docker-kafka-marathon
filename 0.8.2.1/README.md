# kafka-marathon

A Marathon-enabled Docker instance containing Apache Kafka.

## Sample Configuration

As decribed in https://mesosphere.github.io/marathon/docs/rest-api.html#post-/v2/apps we need to fire a POST request to the `/v2/apps` endpoint to create a new application.

So, if your Marathon instance is running at http://192.168.0.1:8080 your request could look like the one below. Please set the correct `parameters` values for your individual configuration.

```
curl -XPOST 'http://192.168.0.1:8080/v2/apps' -d '{
    "id": "kafka-cluster",
    "env": {
        "KAFKA_ZOOKEEPER_CONNECT": "192.168.0.1:2181/kafka"
    },
    "container": {
        "docker": {
            "image": "tobilg/kafka-marathon",
            "network": "HOST"
        },
        "type": "DOCKER"
    },
    "cpus": 1,
    "mem": 2048,
    "instances": 2,
    "ports": [0, 0]
}'
```

## How it works

Upon the container startup, the shell script `kafka-marathon-bootstrap.sh` is executed, which creates a `custom-server.properties` with custom properties derived from the configuration (host & port) Marathon provides, as well as the `KAFKA_ZOOKEEPER_CONNECT` environment variable given upon the app's start.

This is done dynamically at instance start, meaning that if you scale the application via the Marathon frontend, the further instances are automatically added to the given cluster (which is managed via Zookeeper).

The networking is done via `HOST` networking with dynamically assigned ports for the broker and the JMX port via Mesos. Therefore, we request two available ports via the `"ports": [0, 0]` property setting.
See the `ports` [documentation](https://github.com/mesosphere/marathon/blob/master/src/main/resources/mesosphere/marathon/api/v2/AppsResource_create.md#post-v2apps) of Marathon.

> An array of required port resources on the host. To generate one or more arbitrary free ports for each application instance, pass zeros as port values. Each port value is exposed to the instance via environment variables `$PORT0`, `$PORT1`, etc. Ports assigned to running instances are also available via the task resource.

This is necessary for the cluster discovery via ZooKeeper.

### Zookeeper configuration

If you run a single Zookeeper instance, you can use the sample `KAFKA_ZOOKEEPER_CONNECT` as provided above. If you use a Zookeeper cluster, the `KAFKA_ZOOKEEPER_CONNECT` must be created like 
`192.168.0.1:2181,192.168.0.2:2181,192.168.0.3:2181/kafka` for example.