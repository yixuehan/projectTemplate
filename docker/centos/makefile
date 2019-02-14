registry=w505703394
image=centos_boost
tag_base=base
tag_boost=boost
base:
	docker build -t ${registry}/${image}:${tag_base} .
	docker push ${registry}/${image}:${tag_base}

dev:
	docker run --rm -v ${PWD}:/var/opt -w /var/opt ${registry}/${image}:${tag_base} g++ main.cpp

boost:
	docker run --rm -v ${HOME}/git_download/boost:/var/boost \
			-v ${PWD}/boost:/root/boost \
			-w /var/boost  \
		        ${registry}/${image}:${tag_base} \
			./bootstrap.sh --libdir=/root/boost/lib --includedir=/root/boost/include && \
			./bjam cxxflags="-std=c++1y" variant=release install                    
	docker build -t ${registry}/${image}:${tag_boost} -f Dockerfile_boost .
