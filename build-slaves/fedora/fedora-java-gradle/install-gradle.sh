#!/bin/bash
cd /root

# find the most recent version
GRADLE_PACKAGE=`curl -s http://services.gradle.org/distributions --list-only | sed -n 's/.*\(gradle-.*.all.zip\).*/\1/p' | egrep -v "milestone|rc" | head -1`
GRADLE_VERSION=`ls ${GRADLE_PACKAGE} | cut -d "-" -f 1,2`
mkdir /opt/gradle
wget -N http://services.gradle.org/distributions/${GRADLE_PACKAGE}
unzip -oq ./${GRADLE_PACKAGE} -d /opt/gradle

# This is needed a second time, I have no idea why, because it is the same as above.
GRADLE_VERSION=`ls ${GRADLE_PACKAGE} | cut -d "-" -f 1,2`
ln -sfnv ${GRADLE_VERSION} /opt/gradle/latest

# Java Home and export for gradle home
JAVA_HOME=$(dirname $(dirname $(readlink -e $(which java))))
printf "export GRADLE_HOME=/opt/gradle/latest\nexport PATH=\$PATH:\$GRADLE_HOME/bin\nexport JAVA_HOME=${JAVA_HOME}" > /etc/profile.d/gradle.sh
. /etc/profile.d/gradle.sh
hash -r ; sync
# check installation
gradle -v