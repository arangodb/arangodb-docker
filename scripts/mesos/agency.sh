#!/bin/bash

(
  echo " ---> Waiting 5 seconds..."

  sleep 5

  echo " ---> Filling agency with life..."

  arangosh --javascript.execute /scripts/mesos/init_agency.js

  echo " ---> Done with initializing"
) &

echo " ---> starting agency on slave $HOST"

exec /usr/libexec/arangodb/etcd-arango --data-dir /data -name agentarango4001
