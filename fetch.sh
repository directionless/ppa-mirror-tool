#!/bin/bash

# This is a small hack. It's designed to be run from CI system, and
# fetch packages out of a remote PPA.
#
# It does this by installing them, thus resolving their
# depenancies. Then enumerating the packages, and downloading them
# again.
#
# In theory, they ought be in the apt cache. But mine were not. Maybe
# there's an argument to force them.

PPA='ppa:adiscon/v8-stable'
SEARCH='adiscon'
PACKAGES="rsyslog rsyslog-gnutls rsyslog-relp"
DIR='/tmp'

set -e

apt-get install --yes --force-yes software-properties-common \
	python-software-properties
add-apt-repository --yes "$PPA"
apt-get update

# Now, install!
apt-get -y --force-yes install $PACKAGES

# Find what we installed
INSTALLED=$(aptitude search -F "%p" "?narrow(?installed,?origin($SEARCH))")
cd $DIR
apt-get download $INSTALLED


