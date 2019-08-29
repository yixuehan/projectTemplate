#!/bin/bash

openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 356 -key ca-key.pem -sha256 -out ca.pem
openssl genrsa -out server-key.pem 4096
