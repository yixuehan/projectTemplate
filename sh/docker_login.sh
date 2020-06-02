#!/bin/bash
username=$1
groupname=$2
uid=$3
gid=$4
workdir=$5
groupadd -g${gid} ${groupname}
useradd -u${uid} -g${gid} -s /bin/bash ${username} 
su - ${username}
