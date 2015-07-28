#!/bin/bash
set -e

# non interactive
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install system deps
echo " ---> Updating ubuntu"
apt-get -y -qq --force-yes update
apt-get -y -qq --force-yes install apt-utils
apt-get -y -qq --force-yes upgrade
apt-get -y -qq --force-yes install curl libssl-dev
apt-get -y -qq --force-yes install build-essential g++ scons ccache gdb bison flex libboost-test-dev exuberant-ctags
apt-get -y -qq --force-yes install git
apt-get -y -qq --force-yes install vim
apt-get -y -qq --force-yes install iputils-ping net-tools
apt-get -y -qq --force-yes install libgoogle-perftools-dev libgoogle-glog-dev
apt-get -y -qq --force-yes install autoconf automake libreadline6-dev libtool

# create data, apps and log directory
mkdir /data /apps /apps-dev /logs
useradd arangodb
chown arangodb:arangodb /data /apps /apps-dev /logs
