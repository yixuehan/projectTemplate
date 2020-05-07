#!/bin/bash

name=mariadb_study

docker stop ${name}
docker rm ${name}

data_dir=/data/mariadb

docker run --name ${name} \
           -v ${data_dir}/${name}/datadir:/var/lib/mysql \
           --network=host \
           -e MYSQL_ROOT_PASSWORD=mariadb123 \
           -d \
           mariadb
