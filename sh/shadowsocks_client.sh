#!/bin/bash
ss-local -s 118.24.20.35 -p 18150 -b 0.0.0.0 -l 1080 -k "test@123@aa" -m aes-256-cfb --fast-open -u
