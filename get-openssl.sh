#!/bin/bash -xe
cd "$(dirname "$0")"

PWD=`pwd`
ROOTDIR=$PWD
VERSION="1.0.1e"
PLATFORM=osx

if [ ! -e openssl-${VERSION}-$PLATFORM.tar.bz2 ]; then
    echo "Downloading openssl-${VERSION}-$PLATFORM.tar.bz2"
    curl -O https://s3.amazonaws.com/artifact.tokbox.com/ext/openssl-osx/openssl-$VERSION-$PLATFORM.tar.bz2
else
    echo "Using openssl-${VERSION}-$PLATFORM.tar.bz2"
fi

mkdir -p "${ROOTDIR}/out.openssl"
tar xvjf openssl-$VERSION-$PLATFORM.tar.bz2 -C out.openssl

mkdir -p ${ROOTDIR}/trunk/$WEBRTC_OUT
if [ ! -h $ROOTDIR/trunk/openssl ]; then
    ln -s $ROOTDIR/out.openssl/include/openssl $ROOTDIR/trunk/openssl
fi

cp out.openssl/lib/*.a $ROOTDIR/trunk/$WEBRTC_OUT