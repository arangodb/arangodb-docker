FROM debian:stretch
MAINTAINER Frank Celler <info@arangodb.com>

ENV ARCHITECTURE amd64
ENV DEB_PACKAGE_VERSION 1
ENV ARANGO_VERSION 3.3.21
ENV ARANGO_URL https://download.arangodb.com/arangodb33/Debian_9.0
ENV ARANGO_PACKAGE arangodb3-${ARANGO_VERSION}-${DEB_PACKAGE_VERSION}_${ARCHITECTURE}.deb
ENV ARANGO_PACKAGE_URL ${ARANGO_URL}/${ARCHITECTURE}/${ARANGO_PACKAGE}
ENV ARANGO_SIGNATURE_URL ${ARANGO_PACKAGE_URL}.asc

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        dirmngr \
        gpg \
    && rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver hkps://hkps.pool.sks-keyservers.net --recv-keys CD8CB0F1E0AD5B52E93F41E7EA93F5E56E751E9B

# need at least
#   openssl to >= 1.1.0j-1~deb9u1
#   sensible-utils to >= 0.0.9+deb9u1
#   curl to >= 7.52.1-5+deb9u8
#   libgcrypt20 to >= 1.7.6-2+deb9u3
#   libtasn1-6 to >= 4.10-1.1+deb9u1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        curl \
        libjemalloc1 \
        libtasn1-6 \
        numactl \
        openssl \
        pwgen \
        sensible-utils \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /docker-entrypoint-initdb.d

# see
#   https://docs.arangodb.com/latest/Manual/Administration/Configuration/Endpoint.html
#   https://docs.arangodb.com/latest/Manual/Administration/Configuration/Logging.html

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
        -e 's!^\s*uid\s*=.*!!' \
        /etc/arangodb3/arangod.conf \
    && chgrp 0 /var/lib/arangodb3 /var/lib/arangodb3-apps \
    && chmod 775 /var/lib/arangodb3 /var/lib/arangodb3-apps \
    && \
    rm -f ${ARANGO_PACKAGE}*
# Note that Openshift runs containers by default with a random UID and GID 0.
# We need that the database and apps directory are writable for this config.

# retain the database directory and the Foxx Application directory
VOLUME ["/var/lib/arangodb3", "/var/lib/arangodb3-apps"]

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# standard port
EXPOSE 8529
CMD ["arangod"]
