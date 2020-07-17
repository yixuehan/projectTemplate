#!/bin/bash
image=jgraph/drawio
tag=latest
name=drawio

# image_dir=/data/${image}/${tag}/drawio

# docker pull ${image}:${tag}

docker stop ${name} || true
docker rm ${name} || true

docker run -d \
           --network=host \
           --name=${name} \
           -p 8080:8080 -p 8443:8443 \
           ${image}:${tag}
