FROM debian:stretch
MAINTAINER Frank Celler <info@arangodb.com>

ENV ARCHITECTURE amd64
ENV DEB_PACKAGE_VERSION 1
ENV ARANGO_VERSION 3.3.5
ENV ARANGO_URL https://download.arangodb.com/arangodb33/Debian_9.0
ENV ARANGO_PACKAGE arangodb3-${ARANGO_VERSION}-${DEB_PACKAGE_VERSION}_${ARCHITECTURE}.deb
ENV ARANGO_PACKAGE_URL ${ARANGO_URL}/${ARCHITECTURE}/${ARANGO_PACKAGE}
ENV ARANGO_SIGNATURE_URL ${ARANGO_PACKAGE_URL}.asc

RUN apt-get update && \
    apt-get install -y --no-install-recommends gpg dirmngr \
    && \
    rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver hkps://hkps.pool.sks-keyservers.net --recv-keys CD8CB0F1E0AD5B52E93F41E7EA93F5E56E751E9B

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libjemalloc1 \
        ca-certificates \
        pwgen \
        curl \
    && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /docker-entrypoint-initdb.d

# see
#   https://docs.arangodb.com/latest/Manual/Administration/Configuration/Endpoint.html
#   https://docs.arangodb.com/latest/Manual/Administration/Configuration/Logging.html
# run as arangodb:arangodb

RUN curl --fail -O ${ARANGO_SIGNATURE_URL} &&       \
    curl --fail -O ${ARANGO_PACKAGE_URL} &&         \
    gpg --verify ${ARANGO_PACKAGE}.asc && \
    (echo arangodb3 arangodb3/password password test | debconf-set-selections) && \
    (echo arangodb3 arangodb3/password_again password test | debconf-set-selections) && \
    DEBIAN_FRONTEND="noninteractive" dpkg -i ${ARANGO_PACKAGE} && \
    rm -rf /var/lib/arangodb3/* && \
    sed -ri \
        -e 's!127\.0\.0\.1!0.0.0.0!g' \
        -e 's!^(file\s*=).*!\1 -!' \
        -e 's!^#\s*uid\s*=.*!uid = arangodb!' \
        -e 's!^#\s*gid\s*=.*!gid = arangodb!' \
        /etc/arangodb3/arangod.conf \
    && \
    rm -f ${ARANGO_PACKAGE}*

# retain the database directory and the Foxx Application directory
VOLUME ["/var/lib/arangodb3", "/var/lib/arangodb3-apps"]

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# standard port
EXPOSE 8529
CMD ["arangod"]
