registry=w505703394
image=centos_boost
tag_base=base
tag_boost=boost
tag_boost_mysql=boost_mysql
base:
	mkdir base
	docker build -t ${registry}/${image}:${tag_base} .
	docker push ${registry}/${image}:${tag_base}

dev:base
	docker run --rm -v ${PWD}:/var/opt -w /var/opt ${registry}/${image}:${tag_base} g++ main.cpp -std=c++1y

boost:boost
	docker run --rm -v ${HOME}/git_download/boost:/tmp/boost \
			-v ${PWD}/boost:/install/boost \
			-w /var/boost  \
		    ${registry}/${image}:${tag_base} \
			bash -c 'cd /var/boost && \
			        ./bootstrap.sh --libdir=/install/boost/lib --includedir=/install/boost/include && \
					./bjam cxxflags="-std=c++1y" variant=release install'
	docker build -t ${registry}/${image}:${tag_boost} -f Dockerfile_boost .
	docker push ${registry}/${image}:${tag_boost}

mysql:mysql
	docker run --rm -v ${PWD}/mysql:/install/mysql \
		            -v ${PWD}:/tmp/mysql \
					-w /tmp/mysql \
					${registry}/${image}:${tag_boost} \
		            bash -c "./mysql.sh"
	docker build -t ${registry}/${image}:${tag_boost_mysql} -f Dockerfile_mysql .
	docker push ${registry}/${image}:${tag_boost_mysql}

