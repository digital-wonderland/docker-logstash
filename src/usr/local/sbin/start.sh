#! /bin/sh

NAME=logstash
DEFAULT=/etc/sysconfig/$NAME

# Fail hard and fast
set -eo pipefail

FORWARDER_DIR=/mnt/logstash-forwarder
# Generate SSL cert/key for logstash-forwarder
if [ ! -f "$FORWARDER_DIR/logstash-forwarder.key" ]; then
    echo "Generating new logstash-forwarder key"
    openssl req -x509 -batch -nodes -newkey rsa:4096 -keyout "$FORWARDER_DIR/logstash-forwarder.key" -out "$FORWARDER_DIR/logstash-forwarder.crt"
fi

# See contents of file named in $DEFAULT for comments
LS_HOME=/var/lib/logstash
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
export HOME JAVACMD JAVA_OPTS LS_HEAP_SIZE LS_JAVA_OPTS LS_USE_GC_LOGGING

$DAEMON $DAEMON_OPTS
