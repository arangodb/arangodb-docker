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
        --configuration /etc/arangodb/arangod-docker.conf \
        "$@" &
  /bin/bash
else
  /usr/sbin/arangod \
        --configuration /etc/arangodb/arangod-docker.conf \
	"$@"
fi
