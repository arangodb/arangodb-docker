#!/bin/bash

echo " ---> starting agency on slave $HOST"

exec /usr/libexec/arangodb/etcd-arango --data-dir /data -name agentarango4001
