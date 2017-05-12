#!/bin/bash

VERSION=$1

if test -z "${VERSION}" ; then 
    echo "usage: $0 Revision"
    exit 1
fi

if test -d "jessie/${VERSION}"; then 
    echo "there already is jessie/${VERSION}! Exit now."
    exit
fi

mkdir -p jessie/${VERSION}

case ${VERSION} in
  2.*)
    cat Dockerfile.templ | sed \
      -e "s;@VERSION@;${VERSION};" \
      > jessie/${VERSION}/Dockerfile
    cp docker-entrypoint.sh jessie/${VERSION}/docker-entrypoint.sh
    ;;

  3.0.*)
    cat Dockerfile3.templ | sed \
      -e "s;@VERSION@;${VERSION};" \
      > jessie/${VERSION}/Dockerfile
    cp docker-entrypoint3.sh jessie/${VERSION}/docker-entrypoint.sh
    ;;

  3.1.*)
    cat Dockerfile31.templ | sed \
      -e "s;@VERSION@;${VERSION};" \
      -e "s;@REPO_TL_DIR@;${REPO_TL_DIR};" \
      > jessie/${VERSION}/Dockerfile
    cp docker-entrypoint3.sh jessie/${VERSION}/docker-entrypoint.sh
    ;;

  3.*)
    cat Dockerfile32.templ | sed \
      -e "s;@VERSION@;${VERSION};" \
      -e "s;@REPO_TL_DIR@;${REPO_TL_DIR};" \
      > jessie/${VERSION}/Dockerfile
    cp docker-entrypoint32.sh jessie/${VERSION}/docker-entrypoint.sh
    ;;

  *)
    echo "unknown version ${VERSION}"
    exit 1
    ;;
esac

git add jessie/${VERSION}
git commit jessie/${VERSION} -m "Add new version ${VERSION}"
git push
