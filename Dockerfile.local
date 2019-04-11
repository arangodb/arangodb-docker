FROM debian:jessie
MAINTAINER Frank Celler <info@arangodb.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgoogle-perftools4 \
        ca-certificates \
        pwgen \
        wget \
    && \
    rm -rf /var/lib/apt/lists/*

COPY arangodb.deb /arangodb.deb

RUN dpkg -i arangodb.deb && \
    sed -ri \
# https://docs.arangodb.com/ConfigureArango/Arangod.html
        -e 's!127\.0\.0\.1!0.0.0.0!g' \
# https://docs.arangodb.com/ConfigureArango/Logging.html
        -e 's!^(file\s*=).*!\1 -!' \
# run as arangodb:arangodb
        -e 's!^#\s*uid\s*=.*!uid = arangodb!' \
        -e 's!^#\s*gid\s*=.*!gid = arangodb!' \
        /etc/arangodb/arangod.conf \
    && \
    rm -f /arangodb.deb

# retain the database directory and the Foxx Application directory
VOLUME ["/var/lib/arangodb", "/var/lib/arangodb-apps"]

COPY docker-entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]

# standard port
EXPOSE 8529
CMD ["arangod"]
