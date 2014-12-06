#!/bin/bash
set -e

# add arangodb source
ARANGO_URL=https://www.arangodb.org/repositories/arangodb2/Debian_7.0
VERSION=`cat /scripts/VERSION`

# check for local (non-network) install
local=no

if test -d /install; then
  local=yes
fi

# install from local source
if test "$local" = "yes";  then

  echo " ---> Using local packages"
  apt-key add - < /install/Release.key
  dpkg -i /install/libicu52_52.1-3_amd64.deb
  dpkg -i /install/arangodb_${VERSION}_amd64.deb

# normal install
else

  # non interactive
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

  # install system deps
  echo " ---> Updating debian"
  apt-get -y -qq --force-yes update
  apt-get -y -qq --force-yes install wget
  apt-get -y -qq install apt-transport-https

  # install arangodb key
  echo "deb $ARANGO_URL/ /" >> /etc/apt/sources.list.d/arangodb.list
  wget --quiet $ARANGO_URL/Release.key
  apt-key add - < Release.key
  rm Release.key

  # install arangodb
  echo " ---> Installing arangodb package"
  cd /tmp
  apt-get -y -qq --force-yes update
  apt-get -y -qq --force-yes download arangodb=${VERSION}
  dpkg --install arangodb_${VERSION}_amd64.deb
  rm arangodb_${VERSION}_amd64.deb

  # cleanup
  echo " ---> Cleaning up"
  apt-get -y -qq --force-yes clean
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

fi

# create data, apps and log directory
mkdir /data /apps /apps-dev /logs
chown arangodb:arangodb /data /apps /apps-dev /logs
