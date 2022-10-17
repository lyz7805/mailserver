#!/bin/sh
TAG="lyz7805/mailserver"

echo "Build the docker img: ${TAG}"

docker build -t ${TAG} .

echo "The image build success, image tag: ${TAG}"
