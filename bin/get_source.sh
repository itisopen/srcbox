#!/bin/bash

. .env

cat << EOT

This tool will:
- clone the source repository
- copy custom tools
- build a docker image containing the source code
- push it to our custom docker registry

EOT

mkdir -p ./build
cd ./build
echo "Cloning source code"
git clone --recursive $EXT_REPO
cd linstt-poc
git fetch --tags
git checkout $(git tag | tail -n 1)
#git submodule update --recursive --remote
git pull --recurse-submodules

mkdir -p $DSTTOOLSDIR
EXCLUDE_PATTERN="--exclude=build --exclude=.git*"
(cd $SRCTOOLSDIR && tar cf - . $EXCLUDE_PATTERN) | (cd $DSTTOOLSDIR && tar xf -)
$SRCTOOLSDIR/bin/package_source.sh

