#FROM centos
FROM w505703394/centos:base

RUN  yum update -y \
  && yum install -y gcc-c++ make mysql-devel wget python-devel python-libxml2 python-lxml git \
  && yum clean all
