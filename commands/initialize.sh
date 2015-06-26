#!/bin/bash
set -e

USER=${ARANGODB_USERNAME:-root}
PASS=${ARANGODB_PASSWORD:-$(pwgen -s -1 16)}
DB=${ARANGODB_DBNAME:-}

# setup user and database
echo "creating initial user, please wait ..."

(
  if [ "$USER" == "root" ];  then
    echo "require(\"org/arangodb/users\").replace(\"root\", \"$PASS\");"
  else
    echo "require(\"org/arangodb/users\").save(\"$USER\", \"$PASS\");"
    echo "require(\"org/arangodb/users\").replace(\"root\", \"$PASS\", false);"
  fi

  if [ ! -z "$DB" ]; then
    echo "db._createDatabase(\"$DB\"); db._useDatabase(\"$DB\");"

    if [ "$USER" == "root" ];  then
      echo "require(\"org/arangodb/users\").replace(\"root\", \"$PASS\");"
    else
      echo "require(\"org/arangodb/users\").save(\"$USER\", \"$PASS\");"
      echo "require(\"org/arangodb/users\").replace(\"root\", \"$PASS\", false);"
    fi
  fi
) | /usr/sbin/arangod --configuration /etc/arangodb/arangod.conf --console --log.file /tmp/arangodb.log --log.tty "" > /dev/null

echo "========================================================================"
echo "ArangoDB User: \"$USER\""
echo "ArangoDB Password: \"$PASS\""
if [ ! -z "$DB" ]; then
    echo "ArangoDB Database: \"$DB\""
fi
echo "========================================================================"

# check for foxxes
if test -f "/foxxes/mounts.json";  then
  echo "checking for foxxes, please wait ..."

  /usr/sbin/arangod --configuration /etc/arangodb/arangod.conf --log.level error --javascript.script /scripts/install-foxxes.js

  echo "installation has finished"
fi

touch /data/.initialized
