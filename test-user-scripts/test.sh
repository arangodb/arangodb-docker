#!/bin/bash
/usr/bin/arangosh \
    --server.endpoint=unix:///tmp/arangodb-tmp.sock \
    --server.password ${ARANGO_ROOT_PASSWORD} \
    --javascript.execute-string "db._create('testcollection_from_sh_test');"
