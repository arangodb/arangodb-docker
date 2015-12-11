# This is a Ubuntu 12.04 bases image with additional software to build and run ArangoDB on Jenkins (v2.6+)
FROM debian:latest
MAINTAINER Heiko Kernbach <heiko@arangodb.com>

ADD scripts/ /tmp/scripts

#add user & group
RUN groupadd arangodb
RUN useradd arangodb -g arangodb

#install libraries
RUN apt-get update
RUN apt-get install -y apt-utils libssl-dev libgoogle-perftools4

#install process
RUN mkdir /etc/arangodb
RUN cp /tmp/scripts/arangod-docker.conf /etc/arangodb

RUN mkdir /home/arangodb/
RUN tar xfvz /tmp/scripts/ArangoDB-*.tar.gz -C /home/arangodb
RUN cp -r /home/arangodb/tmp/arango/usr/local/* /usr/
RUN rm -rf /home/arangodb/
RUN rm -rf /tmp/scripts/ArangoDB-*.tar.gz

# create data, apps and log directory
RUN mkdir /data /apps /apps-dev /logs
RUN chown arangodb:arangodb /data /apps /apps-dev /logs

# expose data, apps and logs
VOLUME ["/data", "/apps", "/apps-dev", "/logs"]

# standard port
EXPOSE 8529

# script permission
RUN chmod a+x /tmp/scripts/start.sh

# start script
CMD ["/tmp/scripts/start.sh"]
