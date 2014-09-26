FROM debian:wheezy
MAINTAINER Mario Pietsch <pmariojo@gmail.com>

# FROM ubuntu:14.04
# Original: MAINTAINER Frank Celler <info@arangodb.org>

# for local installation, uncomment
# ADD ./arangodb /install

# add scripts to install and run ArangoDB
ADD ./scripts /scripts
RUN chmod +x /scripts/*.sh

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
