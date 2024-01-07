set -x
. ./.env

docker login $DOCKER_SERVER -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
docker build --tag $DOCKER_REPO .
docker tag $DOCKER_REPO $DOCKER_IMAGE
docker push $DOCKER_IMAGE

docker build --tag $DOCKER_REPO-teacher -f ./Dockerfile.teacher .

docker run --rm -it -p 8000:7681 --hostname teacher --env DOCKER_IMAGE=${DOCKER_IMAGE} --name $DOCKER_REPO-teacher $DOCKER_REPO-teacher bash

#docker run -v $(pwd)/terraform:/opt/apps/EKSClass/terraform --rm -it --name eks-class eks-class bash



