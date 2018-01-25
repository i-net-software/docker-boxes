#!/bin/bash

TAG="v3"
GITBRANCH=`git rev-parse --abbrev-ref HEAD`
ROOT=$(eval $(printf "%s -f %s/ | xargs dirname" $([ ! -z $(which greadlink) ] && echo readlink | echo greadlink) $(dirname $0)))

case "$1" in
    alpine|ubuntu|fedora|windows)
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
ARTIFACTS=`cd $(dirname $ENVFILE); docker-compose -f "$DOCKERCOMPOSEFILE" config | grep image: | awk '{print $2}'`
echo "Artifacts"
echo "${ARTIFACTS}"
echo "----------------------------------------------------------"

if [ -z "$COMMAND" ] || [ "build" == "$COMMAND" ] || [ "push" == "$COMMAND" ]; then

    echo "Images to build: ${IMAGES}"
    echo "----------------------------------------------------------"

    # build the images if nothing else is set
    for IMG in $IMAGES; do
        echo "Building Image for: $IMG"
        docker-compose -f "$DOCKERCOMPOSEFILE" build "$@" "$IMG"
    done

    for ARTIFACT in $ARTIFACTS; do
        echo "Tagging: '${ARTIFACT}' with '${TAG}'"
        docker tag "$ARTIFACT" "${ARTIFACT}:${TAG}"
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
