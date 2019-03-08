#FROM centos
FROM w505703394/centos:base

ENV CCACHE_DIR=/tmp/ccache \
    CCACHE_SIZE=10G \
    CCACHE_UMASK=0 \
    PATH=/opt/rh/devtoolset-7/root/usr/bin:/opt/rh/rh-python36/root/usr/bin:${PATH}} \
    LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/lib/gcc/x86_64-redhat-linux/7:/opt/rh/devtoolset-7/root/lib64:${LD_LIBRARY_PATH} \
    LD_LIBRARY_PATH=/opt/rh/rh-python36/root/usr/lib64:${LD_LIBRARY_PATH} \
    PKG_CONFIG_PATH=/opt/rh/rh-python36/root/usr/lib64/pkgconfig:${PKG_CONFIG_PATH} \

#RUN  yum install -y centos-release-scl \
#  && yum install -y devtoolset-7 \
#  && yum install -y epel-release \
#  && yum update -y \
#  && yum install -y make mysql-devel wget rh-python36 python36-devel python36-requests which ccache \
#  && yum clean all \
#  && pip3 install wget \
#  && pip3 install lxml \
#  && ccache --max-size=10G >/dev/null

