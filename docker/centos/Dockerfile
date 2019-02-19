#FROM centos
FROM w505703394/centos:base

RUN  yum install -y centos-release-scl devtoolset-7 \
  && yum install -y centos-release-scl devtoolset-7 \
  && yum install -y epel-release \
  && yum update -y \
  && yum install -y gcc-c++ make mysql-devel wget python-devel which ccache \
  && yum clean all

COPY env.sh /root

#RUN echo '. ~/env.sh' >> ~/.bashrc
