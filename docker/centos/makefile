#!/bin/bash
#source ../../syncgit.sh
registry=registry.cn-shanghai.aliyuncs.com/love996
image=centos
tag_dev_base=dev_base
tag_dev=dev
tag_cmake=cmake
tag_release_base=release_base
tag_release=release
tag_go=go
tag_python=python3
#docker_home=/develop
docker_install_dir=/develop
git_tmp=${PWD}/git_tmp
download_tmp=${PWD}/download_tmp
uid=$(shell id -u)
# uid=0

# set -o errexit
cwd=$(shell pwd)
repo_dir=${HOME}/projectTemplate
docker_repo_dir=/root/projectTemplate

complile_boost:${git_dir}/sh/boost.py build_dev_base
	rm -rf boost_install
	mkdir boost_install
	docker run --rm -u${uid}:${uid} \
					-v ${git_dir}:/src \
		            -v ${cwd}/boost_install:${docker_install_dir}/boost \
					-w /src/sh \
		    		${registry}/${image}:${tag_dev_base} \
					python3 ./boost.py ${docker_install_dir}/boost
	touch complile_boost

complile_mysql:${git_dir}/sh/mysql.sh build_dev_base
	rm -rf mysql_install
	mkdir mysql_install
	docker run --rm -u${uid}:${uid} \
					-v ${git_dir}:/src \
		         	-v ${cwd}/mysql_install:${docker_install_dir}/mysql \
					-w /src/sh \
					${registry}/${image}:${tag_dev_base} \
					./mysql.sh ${docker_install_dir}/mysql
	touch complile_mysql

complile_cmake:${git_dir}/sh/cmake.sh
	rm -rf cmake_install
	mkdir cmake_install
	docker run --rm -u${uid}:${uid} \
					-v ${git_dir}:/src \
		            -v ${cwd}/cmake_install:${docker_install_dir}/cmake \
					-w /src/sh \
					${registry}/${image}:${tag_dev_base} \
					./cmake.sh ${docker_install_dir}/cmake
	touch complile_cmake

complile_json:${git_dir}/sh/json.sh build_cmake
	rm -rf json_install
	mkdir json_install
	docker run --rm -u${uid}:${uid} \
					-v ${git_dir}:/src \
					-w /src/sh \
		            -v ${cwd}/json_install:${docker_install_dir}/json \
		    		${registry}/${image}:${tag_cmake} \
					./json.sh ${docker_install_dir}/json
	touch complile_json

build_cmake:complile_cmake ${git_dir}/sh/cmake.sh Dockerfile_cmake build_dev_base
	docker build -t ${registry}/${image}:${tag_cmake} -f Dockerfile_cmake .
	docker push ${registry}/${image}:${tag_cmake}
	touch build_cmake

dev:Dockerfile_dev
	docker run --rm -v ${repo_dir}/sh:${docker_repo_dir}/sh \
		            -v ${PWD}/git_tmp:${docker_repo_dir}/git_tmp \
					-v ${PWD}/download_tmp:${docker_repo_dir}/download_tmp \
					-v ${HOME}/.ssh:/root/.ssh \
					-v ${PWD}/pkg_tmp:/root/usr \
					-w ${docker_repo_dir}/sh \
					${registry}/${image}:${tag_dev_base} \
					./install.sh cmake boost jsoncpp muduo spdlog sqlite3 nlohmann_json FFmpeg hiredis-v sqlite3 aliyun_oss
					# bash
	# docker build -t ${registry}/${image}:${tag_dev} -f Dockerfile_dev .
	# docker push ${registry}/${image}:${tag_dev}
	touch dev

build_release:build_release_base Dockerfile_release
	docker build -t ${registry}/${image}:${tag_release} -f Dockerfile_release .
	docker push ${registry}/${image}:${tag_release}
	touch build_release

build_alpine_python:Dockerfile_alpine_python
	docker build -t ${registry}/${image_alpine}:${tag_python} -f Dockerfile_alpine_python .
	docker push ${registry}/${image_alpine}:${tag_python}
	touch build_alpine_python

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
