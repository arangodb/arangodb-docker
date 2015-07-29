cd /tmp
rm -Rf arangodb

echo "... cloning ArangoDB ${BRANCH} branch repository."
git clone -b "$BRANCH" http://arangodb:arangodb@gitmirror.germany.triagens-gmbh.zz/git/arangodb.git
cd arangodb

pwd
git --no-pager log -n 1

mkdir /tmp/arango

export CFLAGS="-O2"
export CXXFLAGS="-O2 -static-libstdc++"
export PATH="$PATH:$HOME/go/bin:/usr/local/go/bin"

make setup && ./configure --enable-tcmalloc && make -j 8 && make install DESTDIR=/tmp/arango

TRAVIS_PACKAGE="ArangoDB-${BRANCH}"
buildroot="/tmp/arango"

cd /tmp
mkdir ${TRAVIS_PACKAGE}
mkdir "${TRAVIS_PACKAGE}/bin"

strip "${buildroot}/usr/local/bin/arangob"
strip "${buildroot}/usr/local/sbin/arangod"
strip "${buildroot}/usr/local/bin/arangosh"
strip "${buildroot}/usr/local/bin/arangoimp"
strip "${buildroot}/usr/local/bin/arangodump"
strip "${buildroot}/usr/local/bin/arangorestore"

tar -c -z -f ${TRAVIS_PACKAGE}.tar.gz /tmp/arango || exit 1

mv ${TRAVIS_PACKAGE}.tar.gz /tmp/scripts/packed/

exit 0
