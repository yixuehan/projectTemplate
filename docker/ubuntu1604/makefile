#!/bin/bash
#source ../../syncgit.sh
arm=_arm
registry=registry.cn-shanghai.aliyuncs.com/love996
image=ubuntu1604${arm}
tag_dev_base=dev_base${arm}
tag_native_dev_base=native_dev_base${arm}
tag_dev=dev${arm}
tag_ros=ros${arm}
tag_ros_dev=ros_dev${arm}
tag_native_dev=native_dev${arm}
tag_cmake=cmake${arm}
tag_release_base=release_base${arm}
tag_release=release${arm}
tag_go=go${arm}
tag_python=python3${arm}
#docker_home=/develop
docker_install_dir=/develop
git_tmp=${PWD}/git_tmp
download_tmp=${PWD}/download_tmp
uid=$(shell id -u)
# uid=0

# set -o errexit
cwd=$(shell pwd)
repo_dir=${HOME}/projectTemplate
local_dir=${repo_dir}/docker/cache/ubuntu1604
docker_repo_dir=/root/projectTemplate

build_native_dev:native_dev_base
	docker run --rm -v ${repo_dir}/sh:${docker_repo_dir}/sh \
		            -v ${local_dir}/git_tmp:${docker_repo_dir}/git_tmp \
					-v ${local_dir}/download_tmp:${docker_repo_dir}/download_tmp \
					-v ${PWD}/pkg_tmp:/root/usr \
					-w ${docker_repo_dir}/sh \
					${registry}/${image}:${tag_native_dev_base} \
					./install.sh openssl cmake cryptopp jsoncpp spdlog sqlite3 nlohmann_json yasm libx264 FFmpeg hiredis-v sqlite3 aliyun_oss tcmalloc ccache libev boost muduo

build_dev:dev_base ../../sh/install.sh
	docker run --rm -v ${repo_dir}/sh:${docker_repo_dir}/sh \
		            -v ${local_dir}/git_tmp:${docker_repo_dir}/git_tmp \
					-v ${local_dir}/download_tmp:${docker_repo_dir}/download_tmp \
					-v ${PWD}/pkg_tmp:/root/usr \
					-w ${docker_repo_dir}/sh \
					${registry}/${image}:${tag_dev_base} \
					./install.sh openssl cmake cryptopp jsoncpp spdlog sqlite3 nlohmann_json yasm libx264 FFmpeg hiredis-v sqlite3 aliyun_oss tcmalloc ccache libev boost muduo
	touch build_dev

build_ros_dev:ros ../../sh/install.sh
	docker run --rm -v ${repo_dir}/sh:${docker_repo_dir}/sh \
		            -v ${local_dir}/git_tmp:${docker_repo_dir}/git_tmp \
					-v ${local_dir}/download_tmp:${docker_repo_dir}/download_tmp \
					-v ${PWD}/pkg_tmp:/root/usr \
					-w ${docker_repo_dir}/sh \
					${registry}/${image}:${tag_ros} \
					"./install.sh jsoncpp navigation_msgs"
	touch build_ros_dev



native_dev:Dockerfile_native_dev build_native_dev
	docker build -t ${registry}/${image}:${tag_native_dev} -f Dockerfile_native_dev .
	docker push ${registry}/${image}:${tag_native_dev}
	touch native_dev

ros:Dockerfile_ros
	docker build -t ${registry}/${image}:${tag_ros} -f Dockerfile_ros .
	docker push ${registry}/${image}:${tag_ros}
	touch ros

dev:Dockerfile_dev build_dev
	docker build -t ${registry}/${image}:${tag_dev} -f Dockerfile_dev .
	docker push ${registry}/${image}:${tag_dev}
	touch dev

ros_dev:Dockerfile_ros_dev ros build_dev
	docker build -t ${registry}/${image}:${tag_ros_dev} -f Dockerfile_ros_dev .
	docker push ${registry}/${image}:${tag_ros_dev}
	touch ros_dev

release:Dockerfile_release

release:Dockerfile_release
	docker build -t ${registry}/${image}:${tag_release} -f Dockerfile_release .
	docker push ${registry}/${image}:${tag_release}
	touch release

build_alpine_python:Dockerfile_alpine_python
	docker build -t ${registry}/${image_alpine}:${tag_python} -f Dockerfile_alpine_python .
	docker push ${registry}/${image_alpine}:${tag_python}
	touch build_alpine_python

native_dev_base:Dockerfile_dev_base
	docker build -t ${registry}/${image}:${tag_native_dev_base} -f Dockerfile_dev_base .
	docker push ${registry}/${image}:${tag_native_dev_base}
	touch native_dev_base

dev_base:Dockerfile_dev_base
	docker build -t ${registry}/${image}:${tag_dev_base} -f Dockerfile_dev_base .
	docker push ${registry}/${image}:${tag_dev_base}
	touch dev_base

build_release_base:Dockerfile_release_base
	docker build -t ${registry}/${image}:${tag_release_base} -f Dockerfile_release_base .
	docker push ${registry}/${image}:${tag_release_base}
	touch build_release_base

build_go:Dockerfile_go
	docker build -t ${registry}/${image}:${tag_go} -f Dockerfile_go .
	docker push ${registry}/${image}:${tag_go}
	touch build_go

build_test:main.cpp
	docker run --rm -v ${cwd}:${cwd} -w ${cwd} ${registry}/${image}:${tag_dev_base} g++ main.cpp -std=c++1z
	touch build_test
