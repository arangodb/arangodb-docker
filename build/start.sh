#!/bin/bash

THIS_DIR=`pwd`

BRANCH=""

echo "Script starting."

while getopts ":b:hr" opt; do
  case $opt in
    h)
       cat <<EOT
  This tool is going to deploy a docker image with ubuntu 12.04 with ArangoDB. You have
  to set a branch, otherwise master will be used.
EOT
      exit 0
      ;;
    b)
      BRANCH="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if test -z "$BRANCH";  then
  BRANCH="master"
  echo "... using branch: master."
else
  echo "... using branch: ${BRANCH}."
fi

TMPDIR_NAME="tmp-docker-branch-${BRANCH}"
rm -rf "/tmp/${TMPDIR_NAME}"
rm -rf "${THIS_DIR}/result"
echo "... creating tmp directory."
mkdir "/tmp/${TMPDIR_NAME}"
mkdir "/tmp/${TMPDIR_NAME}/packed"

DOCKER_SCRIPT="install-${BRANCH}.sh"

touch "${THIS_DIR}/scripts/${DOCKER_SCRIPT}"
echo "#!/bin/bash" > "${THIS_DIR}/scripts/${DOCKER_SCRIPT}"
echo "BRANCH=\"${BRANCH}\"" >> "${THIS_DIR}/scripts/${DOCKER_SCRIPT}"
cat "${THIS_DIR}/scripts/setup.sh" >> "${THIS_DIR}/scripts/${DOCKER_SCRIPT}"

echo "... copying scripts to tmp directory."
cp ${THIS_DIR}/scripts/* /tmp/${TMPDIR_NAME}/
chmod a+x /tmp/${TMPDIR_NAME}/*

echo "... starting docker image."
docker run -i --rm -v "/tmp/${TMPDIR_NAME}:/tmp/scripts" arangodb/build-docker /tmp/scripts/${DOCKER_SCRIPT}

mkdir ${THIS_DIR}/result

echo "... moving jenkins build."
cp /tmp/${TMPDIR_NAME}/packed/* ${THIS_DIR}/image/run/scripts/
echo "REMOVE "
mv /tmp/${TMPDIR_NAME}/packed/* ${THIS_DIR}/result/
echo "REMOVE "

echo "... building docker run image"
cd ${THIS_DIR}/image/run
docker build -t --name "arangodb/run-docker" arangodb/run-docker .

echo "... removing tmp directory."
rm -rf /tmp/${TMPDIR_NAME}

echo "... removing tmp files."
rm "${THIS_DIR}/scripts/${DOCKER_SCRIPT}"
rm "${THIS_DIR}/image/run/scripts/ArangoDB-master.tar.gz"

echo "... DONE."
