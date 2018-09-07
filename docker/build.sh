#!/bin/bash

#Variables:
DOCKER_REGISTRY=""
IMAGE_NAME=""
BUILDTAG=""

docker build -t $DOCKER_REGISTRY/$IMAGE_NAME:$TAG .
docker push $DOCKER_REGISTRY/$IMAGE_NAME:$TAG
