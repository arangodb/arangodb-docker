#!/bin/bash

VERSION=$1

if test -z "${VERSION}" ; then 
    echo "usage: $0 Revision"
    exit 1
fi

if test -d "stretch/${VERSION}" -o -d "jessie/${VERSION}" -o -d "alpine/${VERSION}"; then 
    echo "there already is a ${VERSION} version! Exit now."
    exit
fi

case ${VERSION} in
    2.*)
        DOCKER_IMAGE=jessie
        mkdir -p ${DOCKER_IMAGE}/${VERSION}
        cat Dockerfile.templ | sed \
                                   -e "s;@VERSION@;${VERSION};" \
                                   > ${DOCKER_IMAGE}/${VERSION}/Dockerfile
        cp docker-entrypoint.sh ${DOCKER_IMAGE}/${VERSION}/docker-entrypoint.sh
        ;;

    3.0.*)
        DOCKER_IMAGE=jessie
        mkdir -p ${DOCKER_IMAGE}/${VERSION}
        cat Dockerfile3.templ | sed \
                                    -e "s;@VERSION@;${VERSION};" \
                                    > ${DOCKER_IMAGE}/${VERSION}/Dockerfile
        cp docker-entrypoint3.sh ${DOCKER_IMAGE}/${VERSION}/docker-entrypoint.sh
        ;;

    3.1.*)
        if test -z "${REPO_TL_DIR}"; then
            echo "REPO_TL_DIR environment variable missing"
            exit 1
        fi
        DOCKER_IMAGE=stretch
        mkdir -p ${DOCKER_IMAGE}/${VERSION}
        cat Dockerfile31.templ | sed \
                                     -e "s;@VERSION@;${VERSION};" \
                                     -e "s;@REPO_TL_DIR@;${REPO_TL_DIR};" \
                                     > ${DOCKER_IMAGE}/${VERSION}/Dockerfile
        cp docker-entrypoint3.sh ${DOCKER_IMAGE}/${VERSION}/docker-entrypoint.sh
        ;;
    
    3.2.*)
        if test -z "${REPO_TL_DIR}"; then
            echo "REPO_TL_DIR environment variable missing"
            exit 1
        fi
        DOCKER_IMAGE=stretch
        mkdir -p ${DOCKER_IMAGE}/${VERSION}
        cat Dockerfile32.templ | sed \
                                     -e "s;@VERSION@;${VERSION};" \
                                     -e "s;@REPO_TL_DIR@;${REPO_TL_DIR};" \
                                     > ${DOCKER_IMAGE}/${VERSION}/Dockerfile
        cp docker-entrypoint32.sh ${DOCKER_IMAGE}/${VERSION}/docker-entrypoint.sh
        ;;

    3.3.*)
        if test -z "${REPO_TL_DIR}"; then
            echo "REPO_TL_DIR environment variable missing"
            exit 1
        fi
        DOCKER_IMAGE=stretch
        mkdir -p ${DOCKER_IMAGE}/${VERSION}
        cat Dockerfile33.templ | sed \
                                     -e "s;@VERSION@;${VERSION};" \
                                     -e "s;@REPO_TL_DIR@;${REPO_TL_DIR};" \
                                     > ${DOCKER_IMAGE}/${VERSION}/Dockerfile
        cp docker-entrypoint33.sh ${DOCKER_IMAGE}/${VERSION}/docker-entrypoint.sh
        ;;

    3.4.*)
        DOCKER_IMAGE=alpine
        mkdir -p ${DOCKER_IMAGE}/${VERSION}
        cat Dockerfile34.templ | sed \
            -e "s;@VERSION@;${VERSION};" \
            > ${DOCKER_IMAGE}/${VERSION}/Dockerfile
        cp docker-entrypoint34.sh ${DOCKER_IMAGE}/${VERSION}/docker-entrypoint.sh
        cp docker-foxx34.sh ${DOCKER_IMAGE}/${VERSION}/docker-foxx.sh
        ;;

    devel|3.*)
        DOCKER_IMAGE=alpine
        mkdir -p ${DOCKER_IMAGE}/${VERSION}
        cat Dockerfile33.templ | sed \
            -e "s;@VERSION@;${VERSION};" \
            > ${DOCKER_IMAGE}/${VERSION}/Dockerfile
        cp docker-entrypoint34.sh ${DOCKER_IMAGE}/${VERSION}/docker-entrypoint.sh
        cp docker-foxx34.sh ${DOCKER_IMAGE}/${VERSION}/docker-foxx.sh
        ;;

    *)
        echo "unknown version ${VERSION}"
        exit 1
        ;;
esac

# git add ${DOCKER_IMAGE}/${VERSION}
# git commit ${DOCKER_IMAGE}/${VERSION} -m "Add new version ${VERSION}"
# git push
