#!/usr/bin/env bash

# Get Ubuntu 22.04 (jammy) kvm image from https://cloud-images.ubuntu.com

URL=https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img
TAG="volterra.azurecr.io/ves.io/sense8-kubevirt-ubuntu"
PROJECT_URL="https://gitlab.com/volterra/solution/regression/sense8"
VERSION="1.0.0"
IMAGE=$(basename $URL)

if ! test -f $IMAGE; then
  echo downloading $URL ...
  curl -o $IMAGE $URL
else
  echo "using local image <$IMAGE> ..."
fi

echo "resizing image to 50G ..."
qemu-img resize $IMAGE 50G

echo "building docker container $TAG:$VERSION ..."
docker build --label project-url=$PROJECT_URL --tag "$TAG:$VERSION" .

echo ""
docker image ls "$TAG:$VERSION"