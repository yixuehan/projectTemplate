#!/bin/bash
source ../../syncgit.sh
registry=w505703394
image=centos
tag_base=base
tag_dev=dev
tag_cmake=cmake
tag_release=release
tag_release_base=release_base
tag_go=go
cwd=${PWD}
cd ../../
git_dir=${PWD}
download_path=${git_dir}/.git_download
cd ${cwd}


build_base()
{
	docker build -t ${registry}/${image}:${tag_base} .
	docker push ${registry}/${image}:${tag_base}
}

build_release_base()
{
	docker build -t ${registry}/${image}:${tag_release_base} -f Dockerfile_release_base .
	docker push ${registry}/${image}:${tag_release_base}
}

build_go()
{
	docker build -t ${registry}/${image}:${tag_go} -f Dockerfile_go .
	docker push ${registry}/${image}:${tag_go}
}

dev()
{
	docker run --rm -v ${cwd}:/opt/dev -w /opt/dev ${registry}/${image}:${tag_base} g++ main.cpp -std=c++1z
}

boost()
{
	docker run --rm -v ${git_dir}:/src/boost \
		            -v ${cwd}/boost_install:/root/usr \
					-w /src/boost \
		    		${registry}/${image}:${tag_base} \
					python3 ./boost.py
}

mysql()
{
	docker run --rm -v ${cwd}:/src/mysql \
		            -v ${cwd}/mysql.sh:/src/mysql/mysql_install.sh \
		         	-v ${cwd}/mysql_install:/install/mysql \
					-w /src/mysql \
					${registry}/${image}:${tag_base} \
					./mysql_install.sh
	rm -f mysql_install.sh
}

cmake()
{
	docker run --rm -v ${cwd}:/src/cmake \
		            -v ${cwd}/cmake.sh:/src/cmake/cmake_install.sh \
		            -v ${cwd}/cmake_install:/install/cmake \
					-w /src/cmake \
					${registry}/${image}:${tag_base} \
					./cmake_install.sh
	rm -f cmake_install.sh
}

build_cmake()
{
	docker build -t ${registry}/${image}:${tag_cmake} -f Dockerfile_cmake .
	docker push ${registry}/${image}:${tag_cmake}
}

build_dev()
{
	docker build -t ${registry}/${image}:${tag_dev} -f Dockerfile_dev .
	docker push ${registry}/${image}:${tag_dev}
}

build_release()
{
	docker build -t ${registry}/${image}:${tag_release} -f Dockerfile_release .
	docker push ${registry}/${image}:${tag_release}
}

json()
{
    update_module https://github.com/nlohmann/json.git json ${download_path}
	docker run --rm -v ${download_path}/json:/src/json \
		            -v ${cwd}/json.sh:/src/json/json_install.sh \
					-v ${cwd}/json_install:/install/json \
					-w /src/json \
		    		${registry}/${image}:${tag_cmake} \
					./json_install.sh
	rm -f json_install.sh
}

for f in $* ; do
    eval "${f}"
done
