
docker build --tag eksclass .
docker tag eksclass cindyspirion/test:test1
docker push cindyspirion/test:test1

#docker build --tag eksclass-teacher -f ./Dockerfile.teacher .

#docker run --rm -it -p 8000:7681 --hostname teacher --name eksclass-teacher eksclass-teacher bash

#docker run -v $(pwd)/terraform:/opt/apps/EKSClass/terraform --rm -it --name eks-class eks-class bash



