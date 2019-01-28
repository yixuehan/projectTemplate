
all:
	docker build -t centos_boost:v1 .

dev:
	docker run --rm -v ${PWD}:/var/opt -w /var/opt centos_boost:v1 g++ main.cpp
