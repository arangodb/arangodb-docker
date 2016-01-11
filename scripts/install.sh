#!/bin/bash
set -e

# add arangodb source
VERSION=`cat /scripts/VERSION`

case $VERSION in
  latest)
    ARANGO_REPO=arangodb2
    ;;

  *a*|*b*)
    ARANGO_REPO=unstable
    ;;

  *)
    ARANGO_REPO=arangodb2
    ;;
esac

# set repostory path
ARANGO_URL=https://www.arangodb.com/repositories/${ARANGO_REPO}/Debian_8.0
echo " ---> Using repository $ARANGO_URL and version $VERSION"

# check for local (non-network) install
local=no

if test -d /install; then
  local=yes
fi

# non interactive
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install system deps
echo " ---> Updating debian"
apt-get -y -qq --force-yes update
apt-get -y -qq --force-yes install wget
apt-get -y -qq install apt-transport-https
apt-get -y -qq install pwgen
apt-get -y -qq install libgoogle-perftools4

# install from local source
if test "$local" = "yes";  then
  #groupadd arangodb
  #useradd arangodb -g arangodb
  echo " ---> Using local packages"
  #apt-key add - < /install/Release.key
  dpkg -i /install/arangodb_${VERSION}_amd64.deb

  rm -rf /install

# normal install
else

  # install arangodb
  echo " ---> Installing arangodb package"
  cd /tmp

  if [ "${VERSION}" == "latest" ];  then
    echo " ---> Using repository $ARANGO_URL"

    # install arangodb key
    echo "deb $ARANGO_URL/ /" >> /etc/apt/sources.list.d/arangodb.list
    wget --quiet $ARANGO_URL/Release.key
    apt-key add - < Release.key
    rm Release.key

    # download package
    apt-get -y -qq --force-yes update
    apt-get -y -qq --force-yes download arangodb
    dpkg --install arangodb_*_amd64.deb
    rm arangodb_*_amd64.deb
  else
    wget --quiet "https://www.arangodb.com/repositories/${ARANGO_REPO}/Debian_8.0/amd64/arangodb_${VERSION}_amd64.deb"
    dpkg --install arangodb_${VERSION}_amd64.deb
    rm arangodb_${VERSION}_amd64.deb
  fi

  # cleanup
  echo " ---> Cleaning up"
  apt-get -y -qq --force-yes clean
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

fi

# fix config files
echo " ---> Fixing config files"

(
  cd /etc/arangodb

  echo 'temp-path = /tmp/arangodb' > arangod.conf.new
  sed \
    -e 's~^data-path.*~data-path = /var/lib/arangodb/cluster~' \
    -e 's~^log-path.*~log-path = /var/log/arangodb/cluster~' \
    -e 's~^agent-path.*~agent-path = /usr/bin/arangodb/etcd-arango~' \
    -e 's~^arangod-path.*~arangod-path = /usr/sbin/arangod~' \
    -e 's~^dbserver-config.*~dbserver-config = /etc/arangodb/arangod.conf~' \
    -e 's~^coordinator-config.*~coordinator-config = /etc/arangodb/arangod.conf~' \
    -e 's~^endpoint.*~endpoint = tcp://0.0.0.0:8529~'\
    -e 's~^# uid~uid~' \
    -e 's~^# gid~gid~' < arangod.conf >> arangod.conf.new
  mv arangod.conf.new arangod.conf

  #for i in *.conf; do
  #  sed -e 's~^disable-authentication.*~disable-authentication = no~' < $i > $i.new
  #  mv $i.new $i
  #done
)
