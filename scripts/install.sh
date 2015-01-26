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
ARANGO_URL=https://www.arangodb.com/repositories/${ARANGO_REPO}/Debian_7.0
echo " ---> Using repository $ARANGO_URL and version $VERSION"

# check for local (non-network) install
local=no

if test -d /install; then
  local=yes
fi

# non interactive
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install from local source
if test "$local" = "yes";  then

  if test -f "/install/arangodb_${VERSION}_amd64.deb";  then

    echo " ---> Using local debian package"
    apt-key add - < /install/Release.key
    dpkg -i /install/arangodb_${VERSION}_amd64.deb

  elif test -f "/install/arangodb-${VERSION}.tar.gz";  then

    echo "deb http://http.debian.net/debian testing contrib main" >> /etc/apt/sources.list
    # apt-get -y -qq install libc-dev-bin=2.19-13
    apt-get -y -qq --force-yes update
    apt-get -y -qq install libc6:amd64=2.19-13
    apt-get -y -qq install libstdc++6:amd64=4.9.1-19

    (
      cd /
      tar -x -z -f /install/arangodb-${VERSION}.tar.gz

      getent group arangodb >/dev/null || groupadd -r arangodb 
      getent passwd arangodb >/dev/null || useradd -r -g arangodb -d /usr/share/arangodb -s /bin/false -c "ArangoDB Application User" arangodb 

      install -o arangodb -g arangodb -m 755 -d /var/lib/arangodb
      install -o arangodb -g arangodb -m 755 -d /var/lib/arangodb-apps
      install -o arangodb -g arangodb -m 755 -d /var/log/arangodb
    )

  else
    echo "no suitable package found"
    ls -l /install
    exit 1
  fi

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
    wget "https://www.arangodb.com/repositories/${ARANGO_REPO}/Debian_7.0/amd64/arangodb_${VERSION}_amd64.deb"
    dpkg --install arangodb_${VERSION}_amd64.deb
    rm arangodb_${VERSION}_amd64.deb
  fi

  # cleanup
  echo " ---> Cleaning up"
  apt-get -y -qq --force-yes clean
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

fi

# create data, apps and log directory
mkdir /data /apps /apps-dev /logs
chown arangodb:arangodb /data /apps /apps-dev /logs
