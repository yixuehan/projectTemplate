#!/bin/bash
name=rabbitmq_test
image=rabbitmq
tag=management
# tag=latest

docker stop ${name}
docker rm ${name}

docker run -d \
           --network=host \
           --name ${name} \
           -v /data/${image}/${tag}/data:/var/lib/rabbitmq \
           -e RABBITMQ_DEFAULT_VHOST=my_vhost \
           -e RABBITMQ_DEFAULT_USER=admin \
           -e RABBITMQ_DEFAULT_PASS=admin \
           ${image}:${tag}

           # -v /data/${image}/${tag}/etc:/etc/rabbitmq \
           # -v /data/${image}/${tag}/data:/var/lib/rabbitmq \
           # --hostname myRabbit \
           # -p 5672:5672 \
           # -p 15672:15672 \
