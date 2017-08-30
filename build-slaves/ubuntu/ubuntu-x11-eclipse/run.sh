#!/bin/bash

# Make sure the user directory is owned by the jenkins user
if [ ! -d /home/jenkins ]; then
    mkdir -p /home/jenkins
fi

sudo chown -R jenkins:jenkins /home/jenkins
exec /opt/eclipse/eclipse
