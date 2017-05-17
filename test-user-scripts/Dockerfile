FROM arangodb/arangodb
MAINTAINER Frank Celler <info@arangodb.com>

COPY test.js /docker-entrypoint-initdb.d

COPY test.sh /docker-entrypoint-initdb.d

COPY dumps /docker-entrypoint-initdb.d/dumps

COPY verify.js /
