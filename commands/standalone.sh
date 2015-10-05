#!/bin/bash
set -e

initialize=1

while [ "$#" -gt 0 -a "$1" != "--" ];  do
  opt=$1
  shift

  if [ "$opt" == "--console" ];  then
    console=1
  elif [ "$opt" == "--verbose" ];  then
    verbose=1
  elif [ "$opt" == "--upgrade" ];  then
    upgrade=1
  elif [ "$opt" == "--disable-authentication" ];  then
    disable_authentication=1
  elif [ "$opt" == "--disable-initialize" ];  then
    initialize=0
  elif [ "$opt" == "--help" ];  then
    help=1
  else
    echo "arangodb: unknown option '$opt'"
    exit 1
  fi
done

if [ "$#" -gt 0 -a "$1" == "--" ];  then
  shift
fi

# help
if test "$help" == "1";  then
  cat /HELP.md

  exit 0
fi

echo
echo "starting ArangoDB in stand-alone mode"

# fix permissions
mkdir -p /var/lib/arangodb/cluster
mkdir -p /var/log/arangodb/cluster
mkdir -p /var/lib/arangodb-apps

touch /var/log/arangodb/arangodb.log

rm -rf /tmp/arangodb

chown -R arangodb:arangodb \
    /var/lib/arangodb \
    /var/lib/arangodb-apps \
    /var/log/arangodb

# pipe logfile to standard out
if test "$verbose" == "1";  then
  tail -f /var/log/arangodb/arangodb.log &
fi

# initialize for first run
if test "$initialize" = "1" -a ! -e /var/lib/arangodb/.initialized; then
  /commands/initialize.sh
fi

# without authentication
if test "$disable_authentication" == "1";  then
  AUTH="--server.disable-authentication true"
fi

# start server
if test "$upgrade" == "1";  then
  /usr/sbin/arangod "$@" --upgrade
elif test "$console" == "1";  then
  /usr/sbin/arangod "$@" $AUTH &
  /bin/bash
else
  /usr/sbin/arangod "$@" $AUTH
fi
