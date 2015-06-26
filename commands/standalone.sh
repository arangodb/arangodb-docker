#!/bin/bash
set -e

initialize=1

while [ "$#" -gt 0 ];  do
  opt=$1
  shift

  if [ "$opt" == "--console" ];  then
    console=1
  elif [ "$opt" == "--verbose" ];  then
    verbose=1
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

# help
if test "$help" == "1";  then
  cat /HELP.md

  exit 0
fi

echo
echo "starting ArangoDB in stand-alone mode"

# fix permissions
touch /logs/arangodb.log
rm -rf /tmp/arangodb
mkdir /tmp/arangodb

chown arangodb:arangodb /data /apps /apps-dev /logs /logs/arangodb.log /tmp/arangodb

# pipe logfile to standard out
if test "$verbose" == "1";  then
  tail -f /logs/arangodb.log &
fi

# initialize for first run
if test "$initialize" = "1" -a ! -e /data/.initialized; then
  /commands/initialize.sh
fi

# without authentication
if test "$disable_authentication" == "1";  then
  AUTH="--server.disable-authentication true"
fi

# start server
if test "$console" == "1";  then
  /usr/sbin/arangod "$@" $AUTH &
  /bin/bash
else
  /usr/sbin/arangod "$@" $AUTH
fi
