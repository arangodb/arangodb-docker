#!/bin/bash
mkdir /ArangoDB
cd /ArangoDB
git clone https://github.com/ArangoDB/ArangoDB
cd ArangoDB
make setup
/scripts/myconfigurearangoO3
make -j8
