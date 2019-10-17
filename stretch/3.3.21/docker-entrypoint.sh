#!/bin/bash
set -eo pipefail

AUTHENTICATION="true"
export GLIBCXX_FORCE_NEW=1

# if command starts with an option, prepend arangod
if [ "${1:0:1}" = '-' ]; then
    set -- arangod "$@"
fi

if [ "$1" = 'arangod' ]; then
    # /var/lib/arangodb3 and /var/lib/arangodb3-apps must exist and
    # be writable by the user under which we run the container.

    # Make a copy of the configuration file to patch it, note that this
    # must work regardless under which user we run:
    cp /etc/arangodb3/arangod.conf /tmp/arangod.conf
    cp /etc/arangodb3/arango-init-database.conf /tmp/arango-init-database.conf

    if [ ! -z "$ARANGO_ENCRYPTION_KEYFILE" ]; then
        echo "Using encrypted database"
        sed -i /tmp/arangod.conf -e "s;^.*encryption-keyfile.*;encryption-keyfile=$ARANGO_ENCRYPTION_KEYFILE;"
        ARANGO_STORAGE_ENGINE=rocksdb
    fi

    if [ "$ARANGO_STORAGE_ENGINE" == "rocksdb" ]; then
        echo "choosing Rocksdb storage engine"
        sed -i /tmp/arangod.conf -e "s;storage-engine = auto;storage-engine = rocksdb;"
    elif [ "$ARANGO_STORAGE_ENGINE" == "mmfiles" ]; then
        echo "choosing MMFiles storage engine"
        sed -i /tmp/arangod.conf -e "s;storage-engine = auto;storage-engine = mmfiles;"
    else
        echo "automatically choosing storage engine"
    fi
    if [ ! -f /var/lib/arangodb3/SERVER ] && [ "$SKIP_DATABASE_INIT" != "1" ]; then
        if [ -f "$ARANGO_ROOT_PASSWORD_FILE" ]; then
            ARANGO_ROOT_PASSWORD="$(cat $ARANGO_ROOT_PASSWORD_FILE)"
        fi
        if [ -z "${ARANGO_ROOT_PASSWORD+x}" ] && [ -z "$ARANGO_NO_AUTH" ] && [ -z "$ARANGO_RANDOM_ROOT_PASSWORD" ]; then
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
        
        if [ ! -z "${ARANGO_ROOT_PASSWORD+x}" ]; then
            echo "Initializing root user...Hang on..."
            ARANGODB_DEFAULT_ROOT_PASSWORD="$ARANGO_ROOT_PASSWORD" /usr/sbin/arango-init-database -c /tmp/arango-init-database.conf || true
            export ARANGO_ROOT_PASSWORD
        
            if [ ! -z "${ARANGO_ROOT_PASSWORD}" ]; then
                ARANGOSH_ARGS=" --server.password ${ARANGO_ROOT_PASSWORD} "
            fi
        else
            ARANGOSH_ARGS=" --server.authentication false"
        fi

        echo "Initializing database...Hang on..."

        arangod --config /tmp/arangod.conf \
                --server.endpoint unix:///tmp/arangodb-tmp.sock \
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
    else
        echo "starting over with existing database"
    fi

    # if we really want to start arangod and not bash or any other thing
    # prepend --authentication as the FIRST argument
    # (so it is overridable via command line as well)
    shift

    if [ ! -z "$ARANGO_NO_AUTH" ]; then
	    AUTHENTICATION="false"
    fi

    set -- arangod "$@" --server.authentication="$AUTHENTICATION" --config /tmp/arangod.conf
fi

if [ ! -z "$ARANGO_USE_NUMA_INTERLEAVE_ALL" ]; then
    echo "Will try to enable NUMA interleave on all nodes..."
    # check numactl usability to provide a hint if container is not running in
    # privileged mode
    numa='numactl --interleave=all'
    if $numa true &> /dev/null; then
	set -- $numa "$@"
    else
	echo >&2 "error: cannot use numactl, if you are sure that it is supported by your hardware and system, please check that container is running with --security-opt seccomp=unconfined"
    fi
fi

exec "$@"
