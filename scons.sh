#!/bin/bash
PYTHON=python3
export setenv MYSCONS=`pwd`/src                       
${PYTHON} $MYSCONS/script/scons.py                    
${PYTHON} bootstrap.py build/scons                    
cd build/scons                                        
${PYTHON} setup.py install --prefix=${HOME}/usr       
