#!/bin/bash -xe

#
# This script automates the build process described by webrtc:
# https://code.google.com/p/webrtc/source/browse/trunk/talk/app/webrtc/objc/README
#

gclient config http://webrtc.googlecode.com/svn/trunk
echo "target_os = ['mac']" >> .gclient
gclient sync
cd trunk
export GYP_DEFINES="build_with_libjingle=1 build_with_chromium=0 libjingle_objc=1 OS=mac target_arch=x64"
export GYP_GENERATORS="ninja"
export GYP_GENERATOR_FLAGS="output_dir=out_mac"
export GYP_CROSSCOMPILE=1
gclient runhooks
ninja -C out_mac/Debug -t clean
ninja -C out_mac/Debug libjingle_peerconnection_objc_test

AR=`xcrun -f ar`
PWD=`pwd`
ROOT=$PWD
LIBS_OUT=`find $PWD/out_mac/Debug -d 1 -name '*.a'`
FATTYCAKES_OUT=out.huge
mkdir -p $FATTYCAKES_OUT
cd $FATTYCAKES_OUT
for LIB in $LIBS_OUT
do
    $AR -x $LIB
done
$AR -q libfattycakes.a *.o
cd $ROOT

ARTIFACT=out_mac/artifact
mkdir -p $ARTIFACT/lib
mkdir -p $ARTIFACT/include
cp $FATTYCAKES_OUT/libfattycakes.a out_mac/artifact/lib
HEADERS_OUT=`find net talk third_party webrtc -name *.h`
for HEADER in $HEADERS_OUT
do
    HEADER_DIR=`dirname $HEADER`
    mkdir -p $ARTIFACT/include/$HEADER_DIR
    cp $HEADER $ARTIFACT/include/$HEADER
done

cd $ROOT
REVISION=`svn info $BRANCH | grep Revision | cut -f2 -d: | tr -d ' '`
echo "WEBRTC_REVISION=$REVISION" > build.properties

cd $ARTIFACT
tar cjf fattycakes-$REVISION.tar.bz2 lib include


