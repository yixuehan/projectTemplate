#!/bin/bash
image=mariadb
tag=latest

name=mariadb_test
data_dir=/data/${image}/${tag}/mysql

docker stop ${name}
docker rm ${name}

docker run --name ${name} \
           -v ${data_dir}:/var/lib/mysql \
           --network=host \
           -e MYSQL_ROOT_PASSWORD=mariadb123 \
           -d \
           ${image}:${tag}
