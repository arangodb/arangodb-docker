FROM debian:jessie
MAINTAINER Frank Celler <info@arangodb.com>

ENV ARCHITECTURE amd64
ENV ARANGO_VERSION 3.0.0
ENV ARANGO_URL https://download.arangodb.com/arangodb3/Debian_8.0
ENV ARANGO_PACKAGE arangodb3_${ARANGO_VERSION}_${ARCHITECTURE}.deb
ENV ARANGO_PACKAGE_URL ${ARANGO_URL}/${ARCHITECTURE}/${ARANGO_PACKAGE}
ENV ARANGO_SIGNATURE_URL ${ARANGO_PACKAGE_URL}.asc

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys CD8CB0F1E0AD5B52E93F41E7EA93F5E56E751E9B

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libjemalloc1 \
	libsnappy1 \
        ca-certificates \
        pwgen \
        curl \
    && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /docker-entrypoint-initdb.d

RUN curl -O ${ARANGO_SIGNATURE_URL} &&       \
    curl -O ${ARANGO_PACKAGE_URL} &&         \
    gpg --verify ${ARANGO_PACKAGE}.asc && \
    (echo arangodb3 arangodb/password password test | debconf-set-selections) && \
    (echo arangodb3 arangodb/password_again password test | debconf-set-selections) && \
    DEBIAN_FRONTEND="noninteractive" dpkg -i ${ARANGO_PACKAGE} && \
    rm -rf /var/lib/arangodb3/* && \
    sed -ri \
# https://docs.arangodb.com/latest/Manual/Administration/Configuration/Endpoint.html
        -e 's!127\.0\.0\.1!0.0.0.0!g' \
# https://docs.arangodb.com/latest/Manual/Administration/Configuration/Logging.html
        -e 's!^(file\s*=).*!\1 -!' \
# run as arangodb:arangodb
        -e 's!^#\s*uid\s*=.*!uid = arangodb!' \
        -e 's!^#\s*gid\s*=.*!gid = arangodb!' \
        /etc/arangodb3/arangod.conf \
    && \
    DEBIAN_FRONTEND="noninteractive" apt-get purge -y --auto-remove ca-certificates && \
    rm -f ${ARANGO_PACKAGE}*

# retain the database directory and the Foxx Application directory
VOLUME ["/var/lib/arangodb3", "/var/lib/arangodb-apps3"]

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# standard port
EXPOSE 8529
CMD ["arangod"]
