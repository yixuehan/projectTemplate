#!/bin/bash
#source ../../syncgit.sh
registry=w505703394
image=centos
tag_base=base
tag_dev=dev
tag_cmake=cmake
tag_release=release
tag_release_base=release_base
tag_go=go

# set -o errexit
# cwd=/home/ubuntu/projectTemplate/docker/centos
# git_dir=/home/ubuntu/projectTemplate
# download_path=/home/ubuntu/projectTemplate/.git_download


build_base:Dockerfile
	docker build -t ${registry}/${image}:${tag_base} .
	docker push ${registry}/${image}:${tag_base}
	touch build_base

build_release_base:Dockerfile_release_base
	docker build -t ${registry}/${image}:${tag_release_base} -f Dockerfile_release_base .
	docker push ${registry}/${image}:${tag_release_base}
	touch build_release_base

build_go:Dockerfile_go
	docker build -t ${registry}/${image}:${tag_go} -f Dockerfile_go .
	docker push ${registry}/${image}:${tag_go}
	touch build_go

dev:
	docker run --rm -v ${cwd}:/opt/dev -w /opt/dev ${registry}/${image}:${tag_base} g++ main.cpp -std=c++1z

boost:${git_dir}/boost.py build_base
	docker run --rm -v ${git_dir}:/src/boost \
		            -v ${cwd}/boost_install:/root/usr \
					-w /src/boost \
		    		${registry}/${image}:${tag_base} \
					python3 ./boost.py
	touch boost

mysql:${cwd}/mysql.sh build_base
	docker run --rm -v ${cwd}:/src/mysql \
		            -v ${cwd}/mysql.sh:/src/mysql/mysql_install.sh \
		         	-v ${cwd}/mysql_install:/install/mysql \
					-w /src/mysql \
					${registry}/${image}:${tag_base} \
					./mysql_install.sh
	rm -f mysql_install.sh
	touch mysql


build_cmake:Dockerfile_cmake build_base
	docker run --rm -v ${cwd}:/src/cmake \
		            -v ${cwd}/cmake.sh:/src/cmake/cmake_install.sh \
		            -v ${cwd}/cmake_install:/install/cmake \
					-w /src/cmake \
					${registry}/${image}:${tag_base} \
					./cmake_install.sh
	rm -f cmake_install.sh
	docker build -t ${registry}/${image}:${tag_cmake} -f Dockerfile_cmake .
	docker push ${registry}/${image}:${tag_cmake}
	touch build_cmake

build_dev:boost json mysql Dockerfile_dev
	docker build -t ${registry}/${image}:${tag_dev} -f Dockerfile_dev .
	docker push ${registry}/${image}:${tag_dev}
	touch build_dev

build_release:Dockerfile_release Dockerfile_release_base
	docker build -t ${registry}/${image}:${tag_release} -f Dockerfile_release .
	docker push ${registry}/${image}:${tag_release}
	build_release

json:${cwd}/json_install build_cmake
	docker run --rm -v ${download_path}/json:/src/json \
		            -v ${cwd}/json.sh:/src/json/json_install.sh \
					-v ${cwd}/json_install:/install/json \
					-w /src/json \
		    		${registry}/${image}:${tag_cmake} \
					./json_install.sh
	rm -f json_install.sh
	touch json
