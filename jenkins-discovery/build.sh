#!/bin/bash

if [ -z $(which docker-compose) ]; then
    echo "You have to install 'docker-compose'"
    echo "e.g using: pip install docker-compose"
    echo
fi

if [ -z $(which git) ]; then
    echo "You have to install 'git'"
    echo "e.g using: apt-get install git"
    echo
fi

NEEDS_CLEANUP=0
CHECKOUT_ROOT=/tmp/docker-boxes
DOCKER_COMPOSE_OPTS=
if [ ! -f "./docker-compose.yml" ]; then
    NEEDS_CLEANUP=1

    echo "Needs to clone repository first"
    # if the compose is not here, clone it (empty)
    git clone -n https://github.com/i-net-software/docker-boxes.git --depth 1 "$CHECKOUT_ROOT"
    cd "$CHECKOUT_ROOT"
    # checkout the subdirectory, we only need this
    git checkout HEAD jenkins-discovery
    
    # cd back and forth to preserver the history
    cd -
    DOCKER_COMPOSE_OPTS="-f $CHECKOUT_ROOT/jenkins-discovery/docker-compose.yml
    echo "Running with options: '$DOCKER_COMPOSE_OPTS'"
fi

HOST_ADDRESS=$(hostname -I | awk '{print $1}')

if [ -z $0 ]; then
    docker-compose up -d
    echo "Started the docker-compose.yml content as daemon."
    echo "Check with: 'docker ps'"
else
    docker-compose $DOCKER_COMPOSE_OPTS $@
fi

if [ $NEEDS_CLEANUP == 1 ]; then
    echo "Cleaning up after me"
    rm -rf "$CHECKOUT_ROOT"
fi
