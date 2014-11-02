## About:

[Docker](http://www.docker.com/) image based on [digitalwonderland/base](https://registry.hub.docker.com/u/digitalwonderland/base/)

## Additional Software:

* [Logstash](http://logstash.net/)

## Logstash Configuration:

### Elasticsearch Connection

To connect to Elasticsearch Logstashs [```elasticsearch_http``` output](http://logstash.net/docs/latest/outputs/elasticsearch_http) is used (this allows for greater flexibility regarding the compatible Elasticsearch versions). Hostname and port can be configured via the ```ELASTICSEARCH_PORT_9200_TCP_ADDR``` and ```ELASTICSEARCH_PORT_9200_TCP_PORT``` environment variables. They default to ```elasticsearch``` and ```9200``` respectively.

### Logstash Inputs

The following inputs are enabled:

* [logstash-forwarder](http://logstash.net/docs/latest/inputs/lumberjack) on port ```5043``` & certificates being available in a volume bellow ```/mnt/logstash-forwarder```.
* [tcp](http://logstash.net/docs/latest/inputs/tcp) on port ```3333```
* [syslog](http://logstash.net/docs/latest/inputs/syslog) on port ```1514```. You might want to map that to ```514``` on the host (it had to be above 1024 since logstash is not running as root)
