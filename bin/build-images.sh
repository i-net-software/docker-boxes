#!/bin/bash

TAG="v6"
GITBRANCH=`git rev-parse --abbrev-ref HEAD`
# greadlink: brew install coreutils
ROOT=$(eval $(printf "%s -f %s/ | xargs dirname" $([ ! -z $(which greadlink) ] && echo readlink | echo greadlink) $(dirname $0)))
SDK_TAG=latest

case "$1" in
    alpine|ubuntu|fedora|windows|vs2017|vs2019)
        ENVFILE="${ROOT}/build-slaves/$1/build.env"
        shift 1
    ;;
    jenkins)
        ENVFILE="${ROOT}/jenkins-autosetup/build.env"
        shift 1
    ;;
    *)
        echo "Usage: $0 <type> (push)"
        echo "Please use the type you want to build first (alpine, ubuntu, fedora, windows, v2017, vs2019 or jenkins)"
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
ARTIFACTS=`cd $(dirname $ENVFILE); docker-compose -f "$DOCKERCOMPOSEFILE" config | grep image: | grep -v ${SDK_TAG} | awk '{print $2}'`
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

    FIRST_IMAGE=$(echo $IMAGES | awk '{print $1}')
    BASE_IMAGE_DOCKERFILE=$(docker-compose -f "$DOCKERCOMPOSEFILE" config | sed -nEe "/$FIRST_IMAGE:/!d;N;:loop" -e 's/.*\n//;${p;d;};N;P;/\n\[/D;bloop' | grep context | awk '{print $2}' | head -n 1)
    echo "----------------------------------------------------------------------------------"
    for PULL_CONTAINER in $(cat "$BASE_IMAGE_DOCKERFILE/Dockerfile" | grep "^FROM" | awk '{print $2}'); do
        echo "Pulling FROM: '$PULL_CONTAINER'"
        docker pull "${PULL_CONTAINER}" || echo "Could not load newer image '${PULL_CONTAINER}' ..."
    done
    echo "----------------------------------------------------------------------------------"

    # build the images if nothing else is set
    for IMG in $IMAGES; do
        echo "Building Image for: $IMG"
        docker-compose -f "$DOCKERCOMPOSEFILE" build $REGISTRY_ARG "$@" "$IMG"
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
