#!/bin/bash

dir_name=mysql-connector-c++-8.0.14-linux-ubuntu18.04-x86-64bit
tar_name=${dir_name}.tar.gz
if [ ! -f ${tar_name} ]
then
    wget https://cdn.mysql.com/archives/mysql-connector-c++/${tar_name}
    tar -xf ${tar_name}
fi
rm -rf ${HOME}/usr/include/mysqlx
cp -R ${dir_name}/include/mysqlx ${HOME}/usr/include
cp ${dir_name}/lib64/libmysqlcppconn8-static.a ${HOME}/usr/lib
cp ${dir_name}/lib64/libmysqlcppconn-static.a ${HOME}/usr/lib
if [ 0 -eq $? ]
then
    :
    #cd ../..
    #rm -rf ${tar_name}
    #rm -rf ${dir_name}
fi
