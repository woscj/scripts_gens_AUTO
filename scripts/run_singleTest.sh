#!/bin/bash

username=`whoami`

python_path=/home/$username/.pyenv/shims/python

ccx_path=/home/$username/work/ccx/ccx_2.14
gens_path=/home/$username/work/gens_libs

# add system envs
export PYTHONPATH=$gens_path/meshgen/py/dist/
export LD_LIBRARY_PATH=$gens_path/meshgen/lib/linux64/3rdparty/:$gens_path/meshgen/lib/linux64/simright/
export CALCULIX_CCX_EXE=$ccx_path

#$python_path /home/simright/work/gens_libs/viewgen-node/tests/test_webview2.py 
$python_path /home/simright/work/gens_libs/caegen-node/tests/test_caegen.py 
