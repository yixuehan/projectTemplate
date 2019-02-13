#!/bin/bash
    https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.15-src.tar.gz
    dir_name=mysql-connector-c++-8.0.15-src
    tar_name=${dir_name}.tar.gz
if [ ! -f ${tar_name} ]
then
    wget https://dev.mysql.com/get/Downloads/Connector-C++/${tar_name}
    tar -xf ${tar_name}
fi
cd ${dir_name}
mkdir build
cd build
cmake -DBUILD_STATIC=on -DCMAKE_INSTALL_PREFIX=${HOME}/usr ..
rm -rf ${HOME}/usr/include/mysqlx
make install
cp libmysqlcppconn8-static.a ${HOME}/usr/lib
if [ 0 -eq $? ]
then
    :
    cd ../..
    rm -rf ${tar_name}
    rm -rf ${dir_name}
fi
