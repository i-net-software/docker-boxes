#!/bin/bash

TAG="v1"
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
        echo "Please use the type you want to build first (ubuntu, fedora or jenkins)"
        echo "Use 'push' as second option if you want to push the results to hub.docker"
        echo
        exit 1
esac

DOCKERCOMPOSEFILE="$(dirname $ENVFILE)/docker-compose.yml"
source "$ENVFILE"

[ -z "$IMAGES" ] && echo "No images set to be build." && exit 2 || :

# build the image
for IMG in $IMAGES; do
    docker-compose -f "$DOCKERCOMPOSEFILE" build "$IMG"
done

ARTIFACTS=`docker-compose -f "$DOCKERCOMPOSEFILE" config | grep image: | awk '{print $2}'`
for ARTIFACT in $ARTIFACTS; do
    docker tag "$ARTIFACT" "${ARTIFACT%%:*}:${TAG}"
done

if [ "$2" == "push" ]; then
    for ARTIFACT in $ARTIFACTS; do
        docker push "$ARTIFACT"
    done

    if [ "$GITBRANCH" == "master" ]; then
        for ARTIFACT in $ARTIFACTS; do
            docker push "${ARTIFACT%%:*}:latest"
        done
    fi
fi
