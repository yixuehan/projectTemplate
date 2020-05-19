#!/bin/bash
image=eclipse-mosquitto
tag=latest
name=mqtt_test

image_dir=/data/${image}/${tag}/mosquitto

config_file=${image_dir}/config/mosquitto.conf
config_dir=$(dirname ${config_file})

if [ -d ${config_dir} ]
then
    sudo bash -c "mkdir -p ${config_dir} && touch ${config_file}"
fi

if [ -f ${config_file} ]
then
    sudo bash -c "touch ${config_file}"
fi

docker pull ${image}:${tag}

docker stop ${name} || true
docker rm ${name} || true

docker run -d \
           --name=${name} \
           -p 1883:1883 -p 9001:9001 \
           -v ${config_file}:/mosquitto/config/mosquitto.conf \
           -v ${image_dir}/data:/mosquitto/data \
           -v ${image_dir}/log:/mosquitto/log \
           ${image}:${tag}
