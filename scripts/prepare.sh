#!/bin/bash
set -e

# non interactive
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install system deps
echo " ---> Updating debian"
apt-get -y -qq --force-yes update
apt-get -y -qq --force-yes install wget
apt-get -y -qq install apt-transport-https
