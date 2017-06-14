#!/bin/bash
set -eo pipefail

AUTHENTICATION="true"
export GLIBCXX_FORCE_NEW=1

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

    if [ ! -z "$ARANGO_ENCRYPTION_KEYFILE" ]; then
        echo "Using encrypted database"
        sed -i /etc/arangodb3/arangod.conf -e "s;^.*encryption-keyfile.*;encryption-keyfile=$ARANGO_ENCRYPTION_KEYFILE;"
        ARANGO_STORAGE_ENGINE=rocksdb
    fi

    if [ "$ARANGO_STORAGE_ENGINE" == "rocksdb" ]; then
        echo "choosing Rocksdb storage engine"
        sed -i /etc/arangodb3/arangod.conf -e "s;storage-engine = auto;storage-engine = rocksdb;"
    elif [ "$ARANGO_STORAGE_ENGINE" == "mmfiles" ]; then
        echo "choosing MMFiles storage engine"
        sed -i /etc/arangodb3/arangod.conf -e "s;storage-engine = auto;storage-engine = mmfiles;"
    else
        echo "automaticaly choosing storage engine"
    fi
    if [ ! -f /var/lib/arangodb3/SERVER ] && [ "$SKIP_DATABASE_INIT" != "1" ]; then
        if [ -f "$ARANGO_ROOT_PASSWORD_FILE" ]; then
            ARANGO_ROOT_PASSWORD="$(cat $ARANGO_ROOT_PASSWORD_FILE)"
        fi
        if [ -z "$ARANGO_ROOT_PASSWORD" ] && [ -z "$ARANGO_NO_AUTH" ] && [ -z "$ARANGO_RANDOM_ROOT_PASSWORD" ]; then
            echo >&2 'error: database is uninitialized and password option is not specified '
            echo >&2 "  You need to specify one of ARANGO_ROOT_PASSWORD, ARANGO_NO_AUTH and ARANGO_RANDOM_ROOT_PASSWORD"
            exit 1
        fi
        
        if [ ! -z "$ARANGO_RANDOM_ROOT_PASSWORD" ]; then
            ARANGO_ROOT_PASSWORD=$(pwgen -s -1 16)
            echo "==========================================="
            echo "GENERATED ROOT PASSWORD: $ARANGO_ROOT_PASSWORD"
            echo "==========================================="
        fi
        
	    if [ ! -z "$ARANGO_ROOT_PASSWORD" ]; then
            echo "Initializing root user...Hang on..."
            ARANGODB_DEFAULT_ROOT_PASSWORD="$ARANGO_ROOT_PASSWORD" /usr/sbin/arango-init-database || true
            export ARANGO_ROOT_PASSWORD
            ARANGOSH_ARGS=" --server.password ${ARANGO_ROOT_PASSWORD} "
        else
            ARANGOSH_ARGS=" --server.authentication false"
        fi

        echo "Initializing database...Hang on..."

        arangod --server.endpoint unix:///tmp/arangodb-tmp.sock \
                --server.authentication false \
		--log.file /tmp/init-log \
		--log.foreground-tty false &
        pid="$!"

        counter=0
        ARANGO_UP=0

        while [ "$ARANGO_UP" = "0" ]; do
            if [ $counter -gt 0 ]; then
            sleep 1
            fi

            if [ "$counter" -gt 100 ]; then
            echo "ArangoDB didn't start correctly during init"
            cat /tmp/init-log
            exit 1
            fi
            let counter=counter+1
            ARANGO_UP=1
                arangosh \
                    --server.endpoint=unix:///tmp/arangodb-tmp.sock \
                    --server.authentication false \
                    --javascript.execute-string "db._version()" \
                    > /dev/null 2>&1 || ARANGO_UP=0
        done

        for f in /docker-entrypoint-initdb.d/*; do
            case "$f" in
            *.sh)
                        echo "$0: running $f"
                        . "$f"
                        ;;
            *.js)
                        echo "$0: running $f"
                        arangosh ${ARANGOSH_ARGS} \
                                --server.endpoint=unix:///tmp/arangodb-tmp.sock \
                                --javascript.execute "$f"
                        ;;
            */dumps)
                        echo "$0: restoring databases"
                        for d in $f/*; do
                            DBName=$(echo ${d}|sed "s;$f/;;")
                            echo "restoring $d into ${DBName}";
                            arangorestore \
                                ${ARANGOSH_ARGS} \
                                --server.endpoint=unix:///tmp/arangodb-tmp.sock \
                                --create-database true \
                                --include-system-collections true \
                                --server.database "$DBName" \
                                --input-directory "$d"
                        done
                        echo
                        ;;
            esac
        done

        if ! kill -s TERM "$pid" || ! wait "$pid"; then
                echo >&2 'ArangoDB Init failed.'
                exit 1
        fi

        echo "Database initialized...Starting System..."
    fi

    # if we really want to start arangod and not bash or any other thing
    # prepend --authentication as the FIRST argument
    # (so it is overridable via command line as well)
    shift

    if [ ! -z "$ARANGO_NO_AUTH" ]; then
	    AUTHENTICATION="false"
    fi

    set -- arangod --server.authentication="$AUTHENTICATION" "$@"
fi

exec "$@"
