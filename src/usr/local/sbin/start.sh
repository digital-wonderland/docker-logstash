#! /usr/bin/env bash

NAME=logstash
DEFAULT=/etc/sysconfig/$NAME

# Fail hard and fast
set -eo pipefail

export ELASTICSEARCH_PORT_9200_TCP_ADDR=${ELASTICSEARCH_PORT_9200_TCP_ADDR:-elasticsearch}
export ELASTICSEARCH_PORT_9200_TCP_PORT=${ELASTICSEARCH_PORT_9200_TCP_PORT:-9200}

# Generate logstash.conf
confd -onetime -backend env

# Generate SSL cert/key for logstash-forwarder
FORWARDER_DIR=/mnt/logstash-forwarder
if [ ! -f "$FORWARDER_DIR/logstash-forwarder.key" ]; then
    echo "Generating new logstash-forwarder key"
    openssl req -x509 -batch -nodes -newkey rsa:4096 -keyout "$FORWARDER_DIR/logstash-forwarder.key" -out "$FORWARDER_DIR/logstash-forwarder.crt" -subj '/CN=*'
fi

# See contents of file named in $DEFAULT for comments
LS_HOME="/var/lib/logstash"
LS_HEAP_SIZE="500m"
LS_JAVA_OPTS="-Djava.io.tmpdir=${LS_HOME}"
LS_CONF_DIR=/etc/logstash/conf.d
LS_OPTS=""

# End of variables that can be overwritten in $DEFAULT

if [ -f "$DEFAULT" ]; then
  . "$DEFAULT"
fi

DAEMON="/opt/logstash/bin/logstash"
DAEMON_OPTS="agent -f ${LS_CONF_DIR} ${LS_OPTS}"

# Prepare environment
HOME="${HOME:-$LS_HOME}"
JAVACMD="/usr/bin/java"
JAVA_OPTS="${LS_JAVA_OPTS}"
cd "${LS_HOME}"
export HOME JAVACMD JAVA_OPTS LS_HEAP_SIZE LS_JAVA_OPTS LS_USE_GC_LOGGING DAEMON DAEMON_OPTS

su -s /bin/bash logstash -c "$DAEMON $DAEMON_OPTS"
