#!/bin/bash

echo " ---> starting agency on slave $HOST"

/usr/libexec/arangodb/etcd-arango --data-dir /data -name agentarango4001 &

echo " ---> Waiting 5 seconds..."

sleep 5

echo " ---> Filling agency with life..."

arangosh --javascript.execute /scripts/mesos/init_agency.js

echo " ---> Done, foregrounding etcd."

fg %1
