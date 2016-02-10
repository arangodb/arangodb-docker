#!/bin/bash
set -eo pipefail

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
	set -- arangod "$@"
fi

if [ "$1" = 'arangod' ]; then
	DATADIR=/var/lib/arangodb
	
        # ensure proper uid and gid (for example when volume is mounted from the outside)
        chown -R arangodb:arangodb "$DATADIR"
	chown -R arangodb:arangodb /var/lib/arangodb-apps
	if [ ! -f "$DATADIR"/SERVER ]; then
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
                  /usr/sbin/arangod --console --log.tty "" &> /dev/null
                  sed -ri -e 's!^disable-authentication.*!disable-authentication = false!' /etc/arangodb/arangod.conf
                fi
                # Initialize if not already done
                /usr/sbin/arangod --console --upgrade
	fi
fi

exec "$@"
