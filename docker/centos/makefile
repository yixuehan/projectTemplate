
all:
	docker build -t centos_boost:v1 .

dev:
	docker run --rm -v ${PWD}:/var/opt -w /var/opt centos_boost:v1 g++ main.cpp

boost:
	docker run --rm -v ${HOME}/git_download/boost:/var/boost \
					-v ${PWD}/boost:/root/boost
					-w /var/boost 
		            centos_boost:v1 \
					./bootstrap.sh --libdir=/root/boost/lib --includedir=/root/boost/include && \
					./bjam cxxflags="-std=c++1y" variant=release install                    
	docker build -t w505703394/centos_boost:v2 -f Dockerfile_2 .
