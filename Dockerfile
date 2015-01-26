FROM debian:wheezy
MAINTAINER Frank Celler <info@arangodb.org>

# for local installation, uncomment
ADD ./arangodb /install

# add scripts to install and run ArangoDB
ADD ./scripts /scripts

# add HELP file
ADD ./HELP.md /HELP.md

# update OS
RUN ./scripts/prepare.sh

# install package
RUN ./scripts/install.sh

# expose data, apps and logs
VOLUME ["/data", "/apps", "/apps-dev", "/logs"]

# standard port for arangod
EXPOSE 8529

# standard port for etcd
EXPOSE 4001

# start script
CMD ["/scripts/start.sh"]
