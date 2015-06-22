FROM debian:jessie
MAINTAINER Frank Celler <info@arangodb.com>

# for local installation, uncomment
# ADD ./arangodb /install

# add scripts to install and run ArangoDB
ADD ./scripts /scripts

# install ubuntu package
RUN ./scripts/install.sh

# add commands
ADD ./HELP.md /HELP.md
ADD ./commands /commands

# expose data, apps and logs
VOLUME ["/data", "/apps", "/apps-dev", "/logs"]

# standard port
EXPOSE 8529

# start script
ENTRYPOINT ["/scripts/commands.sh"]
CMD ["standalone"]
