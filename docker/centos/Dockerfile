FROM centos
#FROM w505703394/centos:base

RUN  yum install -y centos-release-scl devtoolset-7 \
  && yum install -y centos-release-scl devtoolset-7 \
  && yum install -y epel-release \
  && yum update -y \
  && yum install -y make mysql-devel wget python-devel which ccache \
  && yum clean all

ENV PATH=/opt/rh/devtoolset-7/root/bin:$PATH

