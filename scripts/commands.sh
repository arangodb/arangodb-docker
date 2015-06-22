#!/bin/sh
set -e

if test "$#" -lt 1 -o "$1" = "help";  then
  exec /commands/help.sh
fi

cmd=$1
shift

if test -f "/commands/${cmd}.sh";  then
  exec /commands/${cmd}.sh "$@"
else
  echo "unknown command: $cmd"
  exit 0
fi
