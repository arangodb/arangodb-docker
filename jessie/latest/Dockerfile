FROM debian:jessie
MAINTAINER Frank Celler <info@arangodb.com>


RUN apt-get -y --force-yes update && \
    apt-get -y --force-yes install \
        apt-transport-https \
        gnupg \
    && \
    apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys C60515C5EC94954D9B5A0302358D849C89A14917 && \
    apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys CD8CB0F1E0AD5B52E93F41E7EA93F5E56E751E9B && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys CD8CB0F1E0AD5B52E93F41E7EA93F5E56E751E9B

ENV ARCHITECTURE amd64
ENV ARANGO_VERSION 2.5.5
ENV ARANGO_URL https://www.arangodb.com/repositories/arangodb2/Debian_8.0
ENV ARANGO_PACKAGE arangodb_${ARANGO_VERSION}_${ARCHITECTURE}.deb
ENV ARANGO_PACKAGE_URL ${ARANGO_URL}/${ARCHITECTURE}/${ARANGO_PACKAGE}
ENV ARANGO_SIGNATURE_URL ${ARANGO_PACKAGE_URL}.asc

RUN echo "deb $ARANGO_URL /" > /etc/apt/sources.list.d/arangodb.list

RUN apt-get update && \
    apt-get install arangodb

# expose the database directory (data), Foxx Application directory (apps, apps-dev) and logs
VOLUME ["/data", "/apps", "/apps-dev", "/logs"]

# standard port
EXPOSE 8529

# add HELP file
COPY ./HELP.md /HELP.md
# start script
COPY ./arangod-docker.conf /etc/arangodb/
COPY ./start.sh /etc/arangodb/
ENTRYPOINT ["/etc/arangodb/start.sh"]
