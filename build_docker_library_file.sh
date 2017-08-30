#!/bin/bash


while [ $# -gt 0 ];  do
    case "$1" in
        --isMajorRelease)
            shift
            NEW_MAJOR_RELEASE=$1
            shift
            ;;
        --gitBranch)
            shift
            GITBRANCH=$1
            shift
            ;;
        --gitTag)
            shift
            GITTAG=$1
            shift
            ;;
        --releaseVersion)
            shift
            RELEASE_VERSION=$1
            shift
            ;;
        *)
            echo "don't understand $1"
            exit 1
            ;;
    esac
done

if [ "${NEW_MAJOR_RELEASE}" == "true" ];  then
    cat library/arangodb \
        | grep -v "${GITBRANCH}" \
        | grep -v latest > /tmp/docker_library_template
else
    cat library/arangodb \
        | grep -v "${GITBRANCH}" > /tmp/docker_library_template
fi

echo "${GITBRANCH}: https://github.com/arangodb/arangodb-docker@${RELEASE_VERSION} stretch/${GITTAG}" >> /tmp/docker_library_template
echo "${GITTAG}: https://github.com/arangodb/arangodb-docker@${RELEASE_VERSION} stretch/${GITTAG}" >> /tmp/docker_library_template

if grep -q latest /tmp/docker_library_template ; then
    echo "This is not our newest branch. - thus this is not going to change the LATEST entry."
else
    echo "Adding this version as the LATEST entry:"
    echo "latest: https://github.com/arangodb/arangodb-docker@${RELEASE_VERSION} stretch/${GITTAG}" >> /tmp/docker_library_template
fi

echo "the official docker library file 'library/arangodb' is now: "
cat /tmp/docker_library_template

# now we send the pull request to the official docker library:
# ############################################################
cp /tmp/docker_library_template library/arangodb
