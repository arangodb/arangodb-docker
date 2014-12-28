#!/bin/bash
set -e

# help
if test "$help" = "1";  then
  cat /HELP.md

  exit 0
else
  echo "show all options:"
  echo "  docker run -e help=1 arangodb"
fi

echo
echo "starting ArangoDB in stand-alone mode"

# start in development mode
if test "$development" = "1";  then
  D1="--javascript.dev-app-path"
  D2="/apps-dev"
fi

# fix permissions
touch /logs/arangodb.log
rm -rf /tmp/arangodb
mkdir /tmp/arangodb

chown arangodb:arangodb /data /apps /apps-dev /logs /logs/arangodb.log /tmp/arangodb

# pipe logfile to standard out
if test "$verbose" = "1";  then
  tail -f /logs/arangodb.log &
fi

# start server
if test "$console" = "1";  then
  /usr/sbin/arangod \
        --uid arangodb \
        --gid arangodb \
        --database.directory /data \
        --javascript.app-path /apps \
        --log.file /logs/arangodb.log \
        --temp-path /tmp/arangodb \
	--server.endpoint tcp://0.0.0.0:8529/ \
        $D1 $D2 \
        "$@" &
  /bin/bash
else
  exec /usr/sbin/arangod \
	--uid arangodb \
	--gid arangodb \
        --database.directory /data \
        --javascript.app-path /apps \
	--log.file /logs/arangodb.log \
        --temp-path /tmp/arangodb \
	--server.endpoint tcp://0.0.0.0:8529/ \
	$D1 $D2 \
	"$@"
fi
