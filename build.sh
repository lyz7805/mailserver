#!/bin/sh
TAG="94love1/mailserver"

echo "Build the docker img: ${TAG}"

docker build -t ${TAG} .

echo "The image build success, image tag: ${TAG}"
