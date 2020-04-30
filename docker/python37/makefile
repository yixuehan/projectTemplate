registry=registry.cn-shanghai.aliyuncs.com/love996
image=python37
tag_dev=codeframework

all:
	docker build -t ${registry}/${image}:${tag_dev} -f Dockerfile_codeframework .
	docker push ${registry}/${image}:${tag_dev}
