FROM ubuntu:15.04
MAINTAINER Max Neunhoeffer <max@arangodb.com>

# add scripts to install and run ArangoDB
ADD ./scripts /scripts

# add HELP file
ADD ./HELP.md /HELP.md

# install ubuntu package
RUN ./scripts/install.sh

# Get ArangoDB from github and compile it
RUN ./scripts/install2.sh

# expose data, apps and logs
VOLUME ["/data", "/apps", "/apps-dev", "/logs"]

# standard port
EXPOSE 8529

# start script
CMD ["/scripts/start.sh"]
