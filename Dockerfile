FROM ubuntu:15.10
MAINTAINER Frank Celler <info@arangodb.com>

# for local installation, uncomment
ADD ./arangodb /install

# add scripts to install and run ArangoDB
ADD ./scripts /scripts

# install ubuntu package
RUN ./scripts/install.sh

# add commands
ADD ./HELP.md /HELP.md
ADD ./commands /commands

# copy any required foxxes
ADD ./foxxes /var/lib/arangodb-foxxes

# copy any local config files
ADD ./local-config /etc/arangodb

# expose data, apps and logs
VOLUME ["/var/lib/arangodb", "/var/lib/arangodb-apps", "/var/log/arangodb", "/var/lib/arangodb-foxxes"]

# standard port
EXPOSE 8529

# start script
ENTRYPOINT ["/scripts/commands.sh"]
CMD ["standalone"]
