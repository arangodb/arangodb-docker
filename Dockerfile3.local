FROM debian:jessie
MAINTAINER Frank Celler <info@arangodb.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libjemalloc1 \
	libsnappy1 \
        ca-certificates \
        pwgen \
        curl \
    && \
    rm -rf /var/lib/apt/lists/*

COPY arangodb.deb /arangodb.deb

RUN mkdir /docker-entrypoint-initdb.d

RUN (echo arangodb3 arangodb3/password password test | debconf-set-selections) && \
    (echo arangodb3 arangodb3/password_again password test | debconf-set-selections) && \
    DEBIAN_FRONTEND="noninteractive" dpkg -i arangodb.deb && \
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
    rm -f /arangodb.deb

# retain the database directory and the Foxx Application directory
VOLUME ["/var/lib/arangodb3", "/var/lib/arangodb3-apps"]

COPY docker-entrypoint3.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]

# standard port
EXPOSE 8529
CMD ["arangod"]
