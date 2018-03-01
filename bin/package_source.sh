#!/bin/bash
# Author: Patrice Lachance (patrice.lachance@socgen.com)
##############################################################################

err() {
  echo "Error: $*"
  exit 1
}

[ -z "$CUSTOM_REGISTRY" ] && err "Env variable 'CUSTOM_REGISTRY' not defined"
[ -z "$IMGNAME" ] && err "Env variable 'IMGNAME' not defined"

tag=$(git describe --all)
imgtag="$CUSTOM_REGISTRY/${IMGNAME}:$tag"

echo "Creating source code docker image '$IMGNAME'"
echo " -> building image '$imgtag'"
docker build -f $DSTTOOLSDIR/docker/Dockerfile.alpine -t $imgtag .

echo " -> pushing to custom registry '$CUSTOM_REGISTRY'"
docker push $imgtag

echo " -> Done!"
