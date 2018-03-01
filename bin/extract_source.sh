#!/bin/bash

usage() {

  cat <<EOT

  Usage: docker run -it --rm -v targetdir:/data uid gid

  For example:
    docker run -it --rm -v targetdir:/data \$(id -u) \$(id -g)

EOT
  exit 1
}

err() {
  echo
  echo "Error: $*"

  usage
  exit 1
}

uid=$1
gid=$2

[ -z "$uid" ] && err "Parameter UID empty"
[ -z "$gid" ] && err "Parameter GID empty"

tag=$(git describe --all)
target_dir=/data/src-$tag

echo " -> creating target directory '$target_dir'"
mkdir $target_dir

echo " -> copying files"
cp -a .env* .git* .openshift * $target_dir

echo " -> fixing ownership"
chown -Rh ${uid}:${gid} $target_dir
