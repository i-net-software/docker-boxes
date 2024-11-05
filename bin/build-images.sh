#!/bin/bash

TAG="v4"
GITBRANCH=`git rev-parse --abbrev-ref HEAD`
# greadlink: brew install coreutils
ROOT=$(eval $(printf "%s -f %s/ | xargs dirname" $([ ! -z $(which greadlink) ] && echo readlink | echo greadlink) $(dirname $0)))
SDK_TAG=latest
DOCKER_COMPOSE=$(docker compose 1>/dev/null 2>/dev/null && [ $? -eq 0 ] && echo "docker compose" || echo "docker-compose")
DOCKER_COMPOSE=docker-compose

case "$1" in
    alpine|ubuntu|fedora|windows|vs2017)
        ENVFILE="${ROOT}/build-slaves/$1/build.env"
        shift 1
    ;;
    jenkins)
        ENVFILE="${ROOT}/jenkins-autosetup/build.env"
        shift 1
    ;;
    *)
        echo "Usage: $0 <type> (push)"
        echo "Please use the type you want to build first (alpine, ubuntu, fedora, windows or jenkins)"
        echo "Use 'push' as second option if you want to push the results to hub.docker"
        echo
        exit 1
esac

# Remove the consumed argument
COMMAND="$1"
shift 1

DOCKERCOMPOSEFILE="$(dirname $ENVFILE)/docker-compose.yml"
echo "Compose File: '$DOCKERCOMPOSEFILE'"
echo "Sourcing Environment: '$ENVFILE'"
source "$ENVFILE"

[ -z "$IMAGES" ] && echo "No images set to be build." && exit 2 || :
ARTIFACTS=`cd $(dirname $ENVFILE); $DOCKER_COMPOSE -f "$DOCKERCOMPOSEFILE" config | grep image: | grep -v ${SDK_TAG} | awk '{print $2}'`
echo "Artifacts"
echo "${ARTIFACTS}"
echo "----------------------------------------------------------"

if [ -z "$COMMAND" ] || [ "build" == "$COMMAND" ] || [ "push" == "$COMMAND" ]; then

    echo "Images to build: ${IMAGES}"
    echo "----------------------------------------------------------"
    for ARTIFACT in $ARTIFACTS; do
        echo "Reverse Tagging: '${TAG}' with '${ARTIFACT}'"
        docker tag "${ARTIFACT}:${TAG}" "$ARTIFACT"
    done
    echo "----------------------------------------------------------"

    if [ ! -z "$REGISTRY" ]; then
        REGISTRY_ARG="--build-arg REGISTRY=$REGISTRY"
    fi

    # build the images if nothing else is set
    for IMG in $IMAGES; do
        echo "Building Image for: $IMG"
        docker compose -f "$DOCKERCOMPOSEFILE" build --no-cache $REGISTRY_ARG "$@" "$IMG"
        if [ $? -ne 0 ]; then
            echo "ERROR - could not build image"
            break;
        fi
    done

    for ARTIFACT in $ARTIFACTS; do
        echo "Tagging: '${ARTIFACT}' with '${TAG}' and removing '${ARTIFACT}'"
        docker tag "$ARTIFACT" "${ARTIFACT}:${TAG}"
        docker rmi "${ARTIFACT}:latest"
    done
fi

if [ "pull" == "$COMMAND" ] || [ "push" == "$COMMAND" ]; then
    for ARTIFACT in $ARTIFACTS; do
        docker $COMMAND "${ARTIFACT}:${TAG}"
    done

    if [ "$GITBRANCH" == "master" ] || [ "pull" == "$COMMAND" ]; then
        for ARTIFACT in $ARTIFACTS; do
            docker $COMMAND "${ARTIFACT}:latest"
        done
    fi
fi
