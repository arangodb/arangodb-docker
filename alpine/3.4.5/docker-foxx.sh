#!/bin/sh
test -d /tmp/foxx || mkdir -m 700 /tmp/foxx
export HOME=/tmp/foxx
exec /usr/lib/node_modules/foxx-cli/bin/foxx "$@"
