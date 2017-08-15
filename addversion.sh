#!/bin/bash

VERSION=$1

if test -z "${VERSION}" ; then 
    echo "usage: $0 Revision"
    exit 1
fi

if test -d "stretch/${VERSION}" -o -d "jessie/${VERSION}"; then 
    echo "there already is stretch / jessie ${VERSION}! Exit now."
    exit
fi

mkdir -p stretch/${VERSION}

case ${VERSION} in
    2.*)
        DEB_VERSION=jessie
        cat Dockerfile.templ | sed \
                                   -e "s;@VERSION@;${VERSION};" \
                                   > ${DEB_VERSION}/${VERSION}/Dockerfile
        cp docker-entrypoint.sh ${DEB_VERSION}/${VERSION}/docker-entrypoint.sh
        ;;

    3.0.*)
        DEB_VERSION=jessie
        cat Dockerfile3.templ | sed \
                                    -e "s;@VERSION@;${VERSION};" \
                                    > ${DEB_VERSION}/${VERSION}/Dockerfile
        cp docker-entrypoint3.sh ${DEB_VERSION}/${VERSION}/docker-entrypoint.sh
        ;;

    3.1.*)
        if test -z "${REPO_TL_DIR}"; then
            echo "REPO_TL_DIR environment variable missing"
            exit 1
        fi
        DEB_VERSION=jessie
        cat Dockerfile31.templ | sed \
                                     -e "s;@VERSION@;${VERSION};" \
                                     -e "s;@REPO_TL_DIR@;${REPO_TL_DIR};" \
                                     > ${DEB_VERSION}/${VERSION}/Dockerfile
        cp docker-entrypoint3.sh ${DEB_VERSION}/${VERSION}/docker-entrypoint.sh
        ;;

    3.*)
        if test -z "${REPO_TL_DIR}"; then
            echo "REPO_TL_DIR environment variable missing"
            exit 1
        fi
        DEB_VERSION=stretch
        cat Dockerfile32.templ | sed \
                                     -e "s;@VERSION@;${VERSION};" \
                                     -e "s;@REPO_TL_DIR@;${REPO_TL_DIR};" \
                                     > ${DEB_VERSION}/${VERSION}/Dockerfile
        cp docker-entrypoint32.sh ${DEB_VERSION}/${VERSION}/docker-entrypoint.sh
        ;;

    *)
        echo "unknown version ${VERSION}"
        exit 1
        ;;
esac

git add ${DEB_VERSION}/${VERSION}
git commit ${DEB_VERSION}/${VERSION} -m "Add new version ${VERSION}"
git push
