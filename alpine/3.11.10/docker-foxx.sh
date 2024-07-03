#!/bin/sh
test -d /tmp/foxx || mkdir -m 700 /tmp/foxx
export HOME=/tmp/foxx
exec /usr/local/share/.config/yarn/global/node_modules/.bin/foxx "$@"
