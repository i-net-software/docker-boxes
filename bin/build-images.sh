#!/bin/bash

TAG="v2"
GITBRANCH=`git rev-parse --abbrev-ref HEAD`
ROOT=$(eval $(printf "%s -f %s/ | xargs dirname" $([ ! -z $(which greadlink) ] && echo readlink | echo greadlink) $(dirname $0)))

case "$1" in
    ubuntu|fedora|windows)
        ENVFILE="${ROOT}/build-slaves/$1/build.env"
    ;;
    jenkins)
        ENVFILE="${ROOT}/jenkins-autosetup/build.env"
    ;;
    *)
        echo "Usage: $0 <type> (push)"
        echo "Please use the type you want to build first (ubuntu, fedora, windows or jenkins)"
        echo "Use 'push' as second option if you want to push the results to hub.docker"
        echo
        exit 1
esac

DOCKERCOMPOSEFILE="$(dirname $ENVFILE)/docker-compose.yml"
echo "Compose File: '$DOCKERCOMPOSEFILE'"
echo "Sourcing Environment: '$ENVFILE'"
source "$ENVFILE"

[ -z "$IMAGES" ] && echo "No images set to be build." && exit 2 || :
ARTIFACTS=`cd $(dirname $ENVFILE); docker-compose -f "$DOCKERCOMPOSEFILE" config | grep image: | awk '{print $2}'`
echo "Artifacts"
echo "${ARTIFACTS}"
echo "----------------------------------------------------------"

if [ -z "$2" ] || [ "build" == "$2" ] || [ "push" == "$2" ]; then
    # build the images if nothing else is set
    for IMG in $IMAGES; do
        docker-compose -f "$DOCKERCOMPOSEFILE" build "$IMG"
    done

    for ARTIFACT in $ARTIFACTS; do
        echo "Tagging: '${ARTIFACT}' with '${TAG}'"
        docker tag "$ARTIFACT" "${ARTIFACT%%:*}:${TAG}"
    done
fi

if [ "pull" == "$2" ] || [ "push" == "$2" ]; then
    for ARTIFACT in $ARTIFACTS; do
        docker $2 "${ARTIFACT%%:*}:${TAG}"
    done

    if [ "$GITBRANCH" == "master" ] || [ "pull" == "$2" ]; then
        for ARTIFACT in $ARTIFACTS; do
            docker $2 "${ARTIFACT%%:*}:latest"
        done
    fi
fi
