#!/bin/bash
set -eo pipefail

AUTHENTICATION="false"

# if command starts with an option, prepend arangod
if [ "${1:0:1}" = '-' ]; then
	set -- arangod "$@"
fi


if [ "$1" = 'arangod' ]; then
        mkdir -p /var/lib/arangodb3
        mkdir -p /var/lib/arangodb3-apps
        
        # by doing this here we explicitly break support for mounting volumes from the mac (at least for docker pre 1.11)
        # but otherwise there will be too many problems like this https://github.com/arangodb/arangodb-docker/issues/23
        # mysql as well as postgres are doing it exactly like this so stick to this
        chown -R arangodb /var/lib/arangodb3
        chown -R arangodb /var/lib/arangodb3-apps

	if [ ! -f /var/lib/arangodb3/SERVER ]; then
		if [ -z "$ARANGO_ROOT_PASSWORD" -a -z "$ARANGO_NO_AUTH" -a -z "$ARANGO_RANDOM_ROOT_PASSWORD" ]; then
			echo >&2 'error: database is uninitialized and password option is not specified '
			echo >&2 '  You need to specify one of $ARANGO_ROOT_PASSWORD, $ARANGO_NO_AUTH and $ARANGO_RANDOM_ROOT_PASSWORD'
			exit 1
		fi
                
                echo "Initializing database...Hang on..."
                if [ ! -z "$ARANGO_RANDOM_ROOT_PASSWORD" ]; then
                  ARANGO_ROOT_PASSWORD=$(pwgen -s -1 16)
                  echo "==========================================="
                  echo "GENERATED ROOT PASSWORD: $ARANGO_ROOT_PASSWORD"
                  echo "==========================================="
                fi
                
                if [ ! -z "$ARANGO_ROOT_PASSWORD" ]; then
                  (
                    echo "require(\"org/arangodb/users\").replace(\"root\", \"$ARANGO_ROOT_PASSWORD\");"
                  ) |
                  /usr/sbin/arangod --console --log.foreground-tty false &> /dev/null
                  AUTHENTICATION="true"
                fi
	fi
fi

if [ "$1" == "arangod" ]; then
  # if we really want to start arangod and not bash or any other thing
  # prepend --authentication as the FIRST argument
  # (so it is overridable via command line as well)
  shift
  set -- arangod --server.authentication="$AUTHENTICATION" "$@"
fi

exec "$@"
