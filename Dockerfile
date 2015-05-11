FROM debian:jessie
MAINTAINER Frank Celler <info@arangodb.com>

# for local installation, uncomment
# ADD ./arangodb /install

# add scripts to install and run ArangoDB
ADD ./scripts /scripts

# add HELP file
ADD ./HELP.md /HELP.md

# install ubuntu package
RUN ./scripts/install.sh

# expose data, apps and logs
VOLUME ["/data", "/apps", "/apps-dev", "/logs"]

# standard port
EXPOSE 8529

# start script
CMD ["/scripts/start.sh"]
