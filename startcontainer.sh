#!/bin/bash

# Define the image name and tag
IMAGE_NAME="defects4j"
IMAGE_TAG="latest"

HOST_DIR="./workdir"
CONTAINER_DIR="/workdir"

src="./src"

if [ ! -d "$HOST_DIR" ]; then
    echo "Host directory $HOST_DIR does not exist, creating it..."
    mkdir -p "$HOST_DIR"
fi

docker run -it --rm \
    -v "$HOST_DIR:$CONTAINER_DIR" \
    -v "$src:/src" \
    --name my_container \
    "$IMAGE_NAME:$IMAGE_TAG" \
    /bin/bash

    