#!/bin/bash

REPO="zorbatherainy/nxfilter"
TAG=$(curl https://nxfilter.org/curver.php)

#  Assumes you ran `docker login`

# Check if the tag exists
if docker manifest inspect ${REPO}:${TAG} >/dev/null 2>&1; then
    echo "Tag ${TAG} exists in repository ${REPO}."
    echo "Exiting ..."
else
    echo "Tag ${TAG} does NOT exist in repository ${REPO}."
    echo "Building ..."
    # sudo docker buildx build --build-arg VER_NUM=${TAG} --platform=amd64,arm64 -t ${REPO}:${TAG}  .
    sudo docker build --build-arg VER_NUM=${TAG}  -t ${REPO}:${TAG} .
    docker push ${REPO}:${TAG}
fi
