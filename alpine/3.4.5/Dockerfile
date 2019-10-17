FROM alpine:3.8
MAINTAINER Frank Celler <info@arangodb.com>

ENV ARANGO_VERSION 3.4.5
ENV ARANGO_URL https://download.arangodb.com/arangodb34/DEBIAN/amd64
ENV ARANGO_PACKAGE arangodb3_${ARANGO_VERSION}-1_amd64.deb
ENV ARANGO_PACKAGE_URL ${ARANGO_URL}/${ARANGO_PACKAGE}
ENV ARANGO_SIGNATURE_URL ${ARANGO_PACKAGE_URL}.asc

RUN apk add --no-cache gnupg pwgen nodejs npm binutils && \
    npm install -g foxx-cli && \
    rm -rf /root/.npm

RUN gpg --batch --keyserver hkps://hkps.pool.sks-keyservers.net --recv-keys CD8CB0F1E0AD5B52E93F41E7EA93F5E56E751E9B

RUN mkdir /docker-entrypoint-initdb.d

# see
#   https://docs.arangodb.com/latest/Manual/Administration/Configuration/Endpoint.html
#   https://docs.arangodb.com/latest/Manual/Administration/Configuration/Logging.html

RUN cd /tmp                                && \
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
    echo chgrp 0 /var/lib/arangodb3 /var/lib/arangodb3-apps && \
    echo chmod 775 /var/lib/arangodb3 /var/lib/arangodb3-apps && \
    rm -f /usr/bin/foxx && \
    wget http://dl-cdn.alpinelinux.org/alpine/edge/main/x86_64/numactl-2.0.12-r2.apk && \
    echo "5d6169428e3b8a5d0feda9948a199e9eb676b9a10961f643141f0e462eff38f1  numactl-2.0.12-r2.apk" | sha256sum -c && \
    apk add ./numactl-2.0.12-r2.apk && \
    wget http://dl-cdn.alpinelinux.org/alpine/edge/main/x86_64/numactl-tools-2.0.12-r2.apk && \
    echo "c758d0ea59a50e2d130ae5df1c35c77da935521ac2649183abde16a6bb1fa4d5  numactl-tools-2.0.12-r2.apk" | sha256sum -c && \
    apk add ./numactl-tools-2.0.12-r2.apk && \
    rm -f ${ARANGO_PACKAGE}* data.tar.gz numactl-2.0.12-r2.apk numactl-tools-2.0.12-r2.apk
# Note that Openshift runs containers by default with a random UID and GID 0.
# We need that the database and apps directory are writable for this config.

# retain the database directory and the Foxx Application directory
VOLUME ["/var/lib/arangodb3", "/var/lib/arangodb3-apps"]

COPY docker-entrypoint.sh /entrypoint.sh
copy docker-foxx.sh /usr/bin/foxx

ENTRYPOINT ["/entrypoint.sh"]

# standard port
EXPOSE 8529
CMD ["arangod"]
