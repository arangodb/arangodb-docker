#!/bin/bash

# add arangodb source
ARANGO_URL=http://www.arangodb.org/repositories/arangodb2/xUbuntu_14.04
VERSION=`cat /scripts/VERSION`

# check for local (non-network) install
local=no

if test -d /install; then
  local=yes
fi

# install from local source
if test "$local" = "yes";  then

  echo " ---> Using local ubuntu packages"
  apt-key add - < /install/Release.key
  dpkg -i /install/libicu52_52.1-3_amd64.deb
  dpkg -i /install/arangodb_2.2.2_amd64.deb

# normal install
else

  # non interactive
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

  # install system deps
  echo " ---> Updating ubuntu"
  apt-get -y -qq --force-yes update || exit 1
  apt-get -y -qq --force-yes install wget || exit 1

  # install arangodb key
  echo "deb $ARANGO_URL/ /" >> /etc/apt/sources.list.d/arangodb.list
  wget --quiet $ARANGO_URL/Release.key || exit 1
  apt-key add - < Release.key
  rm Release.key

  # install arangodb
  echo " ---> Installing arangodb package"
  apt-get -y -qq --force-yes update || exit 1
  apt-get -y -qq --force-yes install arangodb=$VERSION || exit 1

  # cleanup
  echo " ---> Cleaning up"
  apt-get -y -qq --force-yes clean
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

fi

# create data, apps and log directory
mkdir /data /apps /apps-dev /logs
touch /logs/arangodb.log

chown arangodb:arangodb /data /apps /apps-dev /logs /logs/arangodb.log
