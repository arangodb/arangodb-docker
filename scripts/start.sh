#!/bin/bash

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

# pipe logfile to standard out
if test "$verbose" = "1";  then
  tail -f /logs/arangodb.log &
fi

# start in development mode
if test "$development" = "1";  then
  D1="--javascript.dev-app-path"
  D2="/apps-dev"
fi

# start server
exec /usr/sbin/arangod \
	--uid arangodb \
	--gid arangodb \
        --database.directory /data \
        --javascript.app-path /apps \
	--log.file /logs/arangodb.log \
	$D1 $D2 \
	"$@"
