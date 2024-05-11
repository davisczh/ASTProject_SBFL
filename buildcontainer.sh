#!/bin/bash

# Define the path to the Dockerfile
DOCKERFILE_PATH="."

# Define the name and tag for the image
IMAGE_NAME="defects4j"
IMAGE_TAG="latest"

# Run the Docker build command
docker build -t $IMAGE_NAME:$IMAGE_TAG $DOCKERFILE_PATH

# Check if the image was built successfully
if [ $? -eq 0 ]; then
    echo "Docker image built successfully: $IMAGE_NAME:$IMAGE_TAG"
else
    echo "Failed to build Docker image"
    exit 1
fi
