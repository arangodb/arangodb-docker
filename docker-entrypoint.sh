#!/bin/bash
set -eo pipefail

DISABLE_AUTHENTICATION="true"

function rwfail {
    echo "We seem to not have proper rw access to $1. Please make sure that every mounted volume has full rw access for user arangodb ($(id arangodb))"
    exit 55
}

# if command starts with an option, prepend arangod
if [ "${1:0:1}" = '-' ]; then
    set -- arangod "$@"
fi


if [ "$1" = 'arangod' ]; then
    DATADIR=/var/lib/arangodb
    
    # ensure proper uid and gid (for example when volume is mounted from the outside)
    # do NOT chown or stuff like that. when using shared folders on the mac chown is VERY likely to fail due to docker => vm => host issues
    touch "$DATADIR"/_rwcheck_$HOSTNAME || rwfail $DATADIR
    rm "$DATADIR"/_rwcheck_"$HOSTNAME"
    touch /var/lib/arangodb-apps/_rwcheck_"$HOSTNAME" || rwfail /var/lib/arangodb-apps/
    rm /var/lib/arangodb-apps/_rwcheck_"$HOSTNAME"
    if [ ! -f "$DATADIR"/SERVER ]; then
	if [ -f "$ARANGO_ROOT_PASSWORD_FILE" ]; then
	    ARANGO_ROOT_PASSWORD="$(cat $ARANGO_ROOT_PASSWORD_FILE)"
	fi
	if [ -z "${ARANGO_ROOT_PASSWORD+x}" -a -z "$ARANGO_NO_AUTH" -a -z "$ARANGO_RANDOM_ROOT_PASSWORD" ]; then
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
        
        if [ ! -z "${ARANGO_ROOT_PASSWORD+x}" ]; then
            (
                echo "require(\"org/arangodb/users\").replace(\"root\", \"$ARANGO_ROOT_PASSWORD\");"
            ) |
                /usr/sbin/arangod --console --log.tty "" &> /dev/null
            DISABLE_AUTHENTICATION="false"
        fi
        # Initialize if not already done
        /usr/sbin/arangod --console --upgrade
    fi
fi

if [ "$1" == "arangod" ]; then
    # if we really want to start arangod and not bash or any other thing
    # prepend --disable-authentication as the FIRST argument
    # (so it is overridable via command line as well)
    shift
    set -- arangod --server.disable-authentication="$DISABLE_AUTHENTICATION" "$@"
fi

exec "$@"
