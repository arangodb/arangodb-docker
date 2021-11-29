FROM alpine:3.12
MAINTAINER Frank Celler <info@arangodb.com>

ENV ARANGO_VERSION 3.7.16
ENV ARANGO_URL https://download.arangodb.com/arangodb37/DEBIAN/amd64
ENV ARANGO_PACKAGE arangodb3_${ARANGO_VERSION}-1_amd64.deb
ENV ARANGO_PACKAGE_URL ${ARANGO_URL}/${ARANGO_PACKAGE}
ENV ARANGO_SIGNATURE_URL ${ARANGO_PACKAGE_URL}.asc

# see
#   https://www.arangodb.com/docs/3.7/programs-arangod-server.html#managing-endpoints
#   https://www.arangodb.com/docs/3.7/programs-arangod-log.html

RUN apk add --no-cache gnupg pwgen binutils numactl numactl-tools nodejs yarn && \
    yarn global add foxx-cli && \
    apk del yarn && \
    gpg --batch --keyserver keys.openpgp.org --recv-keys CD8CB0F1E0AD5B52E93F41E7EA93F5E56E751E9B && \
    mkdir /docker-entrypoint-initdb.d && \
    cd /tmp                                && \
    wget ${ARANGO_SIGNATURE_URL}           && \
    wget ${ARANGO_PACKAGE_URL}             && \
    gpg --verify ${ARANGO_PACKAGE}.asc     && \
    ar x ${ARANGO_PACKAGE} data.tar.gz     && \
    tar -C / -x -z -f data.tar.gz          && \
    sed -ri \
        -e 's!127\.0\.0\.1!0.0.0.0!g' \
        -e 's!^(file\s*=\s*).*!\1 -!' \
        -e 's!^\s*uid\s*=.*!!' \
        /etc/arangodb3/arangod.conf        && \
    chgrp -R 0 /var/lib/arangodb3 /var/lib/arangodb3-apps && \
    chmod -R 775 /var/lib/arangodb3 /var/lib/arangodb3-apps && \
    rm -f /usr/bin/foxx && \
    rm -f ${ARANGO_PACKAGE}* data.tar.gz && \
    apk del gnupg
# Note that Openshift runs containers by default with a random UID and GID 0.
# We need that the database and apps directory are writable for this config.

ENV GLIBCXX_FORCE_NEW=1

# retain the database directory and the Foxx Application directory
VOLUME ["/var/lib/arangodb3", "/var/lib/arangodb3-apps"]

COPY docker-entrypoint.sh /entrypoint.sh
COPY docker-foxx.sh /usr/bin/foxx

ENTRYPOINT ["/entrypoint.sh"]

# standard port
EXPOSE 8529
CMD ["arangod"]
