#!/bin/bash

# default arguments:
DOCKERFILE="./docker/Dockerfile"
LOCAL_DOCKER_IMAGE_LIST=()
TAGS="v1.0"

echo

# check if Dockerfile is present in the folder
if [ $(ls $DOCKERFILE | wc -l) = 0 ]; then
    echo "ERROR: cannot find dockerfile $1/$DOCKERFILE to build"
    exit 1
fi

# Unlike other API/CLI calls, this will always work, regardless of IAM permissions.
# we will use this call to verify that aws is configured properly
aws sts get-caller-identity --region us-east-1
if [ $? != 0 ]; then
    echo "ERROR: aws-cli not configured"
    exit 1
fi

echo "Starting building the images"
cd ./docker
docker build -t $1 .
if [ $? != 0 ]; then
    echo "ERROR: Image building failed"
    exit 1
fi

echo "logging into AWS ECR"
$(aws ecr get-login --region us-east-1 --no-include-email)
if [ $? != 0 ]; then
    echo "ERROR: docker login into AWS ECR Failed "
    exit 1
fi

echo "tagging & pushing image to AWS ECR"
docker tag $1 $2:$TAGS
docker push $2:$TAGS
if [ $? != 0 ]; then
    echo "ERROR: docker pushing image $2:$TAGS failed "
    exit 1
fi

echo "Removing AWS ECR credentials"
docker logout $2

echo "Removing local images generated during this build"
LOCAL_DOCKER_IMAGE_LIST=("${LOCAL_DOCKER_IMAGE_LIST[@]}" $2:$TAGS)
for IMAGE in "${LOCAL_DOCKER_IMAGE_LIST[@]}"; do
    echo "removing image $IMAGE"
    docker rmi $IMAGE
    if [ $? != 0 ]; then
        echo "ERROR: docker removing local image $IMAGE failed "
        echo "please delete this image manually"
        echo
    fi

    echo

done