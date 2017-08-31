FROM debian:jessie
MAINTAINER Frank Celler <info@arangodb.com>

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys CD8CB0F1E0AD5B52E93F41E7EA93F5E56E751E9B

ENV ARCHITECTURE amd64
ENV ARANGO_VERSION 2.7.2
ENV ARANGO_URL https://download.arangodb.com/arangodb2/Debian_8.0
ENV ARANGO_PACKAGE arangodb_${ARANGO_VERSION}_${ARCHITECTURE}.deb
ENV ARANGO_PACKAGE_URL ${ARANGO_URL}/${ARCHITECTURE}/${ARANGO_PACKAGE}
ENV ARANGO_SIGNATURE_URL ${ARANGO_PACKAGE_URL}.asc

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgoogle-perftools4 \
        ca-certificates \
        wget \
    && \
    rm -rf /var/lib/apt/lists/* && \
    wget ${ARANGO_SIGNATURE_URL} &&       \
    wget ${ARANGO_PACKAGE_URL} &&         \
    gpg --verify ${ARANGO_PACKAGE}.asc && \
    dpkg -i ${ARANGO_PACKAGE} && \
    sed -ri \
# https://docs.arangodb.com/ConfigureArango/Arangod.html
        -e 's!127\.0\.0\.1!0.0.0.0!g' \
# https://docs.arangodb.com/ConfigureArango/Logging.html
        -e 's!^(file\s*=).*!\1 -!' \
        /etc/arangodb/arangod.conf \
    && \
    apt-get purge -y --auto-remove ca-certificates wget && \
    rm -f ${ARANGO_PACKAGE}*

# retain the database directory and the Foxx Application directory
VOLUME ["/var/lib/arangodb", "/var/lib/arangodb-apps"]

# standard port
EXPOSE 8529

CMD ["/usr/sbin/arangod"]
