registry=w505703394
image=centos
tag_base=base
tag_dev=dev
tag_cmake=cmake
tag_release=release
tag_release_base=release_base

all:
	echo ${scons_create}

base:
	docker build -t ${registry}/${image}:${tag_base} .
	docker push ${registry}/${image}:${tag_base}

release_base:
	docker build -t ${registry}/${image}:${tag_release_base} -f Dockerfile_release_base .
	docker push ${registry}/${image}:${tag_release_base}


dev:
	docker run --rm -v ${PWD}:/opt/dev -w /opt/dev ${registry}/${image}:${tag_base} g++ main.cpp -std=c++1y

boost:
	docker run --rm -v ${HOME}/git_download/boost:/src/boost \
		            -v ${PWD}/boost.sh:/src/boost/boost_install.sh \
					-v ${PWD}/boost_install:/install/boost \
					-w /src/boost \
		    		${registry}/${image}:${tag_base} \
					./boost_install.sh

mysql:
	docker run --rm -v ${PWD}:/src/mysql \
		            -v ${PWD}/mysql.sh:/src/mysql/mysql_install.sh \
		         	-v ${PWD}/mysql_install:/install/mysql \
					-w /src/mysql \
					${registry}/${image}:${tag_base} \
					./mysql_install.sh

scons:
	docker run --rm -v ${PWD}:/src/scons \
		            -v ${PWD}/scons.sh:/src/scons/scons_install.sh \
		            -v ${PWD}/scons_install:/install/scons \
					-w /src/scons \
					${registry}/${image}:${tag_base} \
					./scons_install.sh

cmake:
	docker run --rm -v ${PWD}:/src/cmake \
		            -v ${PWD}/cmake.sh:/src/cmake/cmake_install.sh \
		            -v ${PWD}/cmake_install:/install/cmake \
					-w /src/cmake \
					${registry}/${image}:${tag_base} \
					./cmake_install.sh

build_cmake:
	docker build -t ${registry}/${image}:${tag_cmake} -f Dockerfile_cmake .
	docker push ${registry}/${image}:${tag_cmake}

build_dev:
	docker build -t ${registry}/${image}:${tag_dev} -f Dockerfile_dev .
	docker push ${registry}/${image}:${tag_dev}

build_release:
	docker build -t ${registry}/${image}:${tag_release} -f Dockerfile_release .
	docker push ${registry}/${image}:${tag_release}

json:
	docker run --rm -v ${HOME}/git_download/json:/src/json \
		            -v ${PWD}/json.sh:/src/json/json_install.sh \
					-v ${PWD}/json_install:/install/json \
					-w /src/json \
		    		${registry}/${image}:${tag_cmake} \
					./json_install.sh


