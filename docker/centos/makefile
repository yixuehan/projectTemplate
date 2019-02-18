registry=w505703394
image=centos
tag_base=base
tag_dev=dev

all:
	echo ${scons_create}

base:
	docker build -t ${registry}/${image}:${tag_base} .
	docker push ${registry}/${image}:${tag_base}

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
	docker run --rm -v ${HOME}/git_download/scons:/src/scons \
		            -v ${PWD}/scons.sh:/src/scons/scons_install.sh \
		            -v ${PWD}/scons_install:/install/scons \
					-w /src/scons \
					${registry}/${image}:${tag_base} \
					./scons_install.sh

build:
	docker build -t ${registry}/${image}:${tag_dev} -f Dockerfile_dev .
	docker push ${registry}/${image}:${tag_dev}
