FROM debian:stretch
MAINTAINER Frank Celler <info@arangodb.com>

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        libjemalloc1 \
        ca-certificates \
        pwgen \
        curl && \
    rm -rf /var/lib/apt/lists/*

COPY arangodb.deb /arangodb.deb

RUN mkdir /docker-entrypoint-initdb.d

# see
#   https://docs.arangodb.com/latest/Manual/Administration/Configuration/Endpoint.html
#   https://docs.arangodb.com/latest/Manual/Administration/Configuration/Logging.html

RUN (echo arangodb3 arangodb3/password password test | debconf-set-selections) && \
    (echo arangodb3 arangodb3/password_again password test | debconf-set-selections) && \
    DEBIAN_FRONTEND="noninteractive" dpkg -i arangodb.deb && \
    rm -rf /var/lib/arangodb3/* && \
    sed -ri \
        -e 's!127\.0\.0\.1!0.0.0.0!g' \
        -e 's!^(file\s*=).*!\1 -!' \
        -e 's!^\s*uid\s*=.*!!' \
        /etc/arangodb3/arangod.conf \
    && chgrp 0 /var/lib/arangodb3 /var/lib/arangodb3-apps \
    && chmod 775 /var/lib/arangodb3 /var/lib/arangodb3-apps \
    && rm -f /arangodb.deb
# Note that Openshift runs containers by default with a random UID and GID 0.
# We need that the database and apps directory are writable for this config.

# retain the database directory and the Foxx Application directory
VOLUME ["/var/lib/arangodb3", "/var/lib/arangodb3-apps"]

COPY docker-entrypoint33.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]

# standard port
EXPOSE 8529
CMD ["arangod"]
