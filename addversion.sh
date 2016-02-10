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

cat Dockerfile.templ | sed \
    -e "s;@VERSION@;${VERSION};" \
    > jessie/${VERSION}/Dockerfile

cp docker-entrypoint.sh jessie/${VERSION}/docker-entrypoint.sh
git add jessie/${VERSION}
git commit jessie/${VERSION} -m "Add new version ${VERSION}"
git push

