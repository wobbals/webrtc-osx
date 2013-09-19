#!/bin/bash -xe
cd "$(dirname "$0")"

PWD=`pwd`
ROOTDIR=$PWD
VERSION="1.0.1c"
PLATFORM=osx

if [ ! -e openssl-${VERSION}.tar.gz ]; then
    echo "Downloading openssl-${VERSION}.tar.gz"
    curl -O http://www.openssl.org/source/openssl-${VERSION}.tar.gz
else
    echo "Using openssl-${VERSION}.tar.gz"
fi

mkdir -p "${ROOTDIR}/src.openssl"
tar zxf openssl-${VERSION}.tar.gz -C "${ROOTDIR}/src.openssl"
cd $ROOTDIR/src.openssl/openssl-${VERSION}
./Configure gcc no-asm --openssldir=out
cd $ROOTDIR
mkdir -p ${ROOTDIR}/trunk
ln -s $ROOTDIR/src.openssl/openssl-${VERSION}/include $ROOTDIR/trunk/openssl

