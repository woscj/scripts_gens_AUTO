#!/usr/bin/env bash

username=`whoami`

export PYTHONPATH=/home/$username/work/gens_libs/meshgen/py/dist/
export LD_LIBRARY_PATH=/home/$username/work/gens_libs/meshgen/lib/linux64/3rdparty/:/home/$username/work/gens_libs/meshgen/lib/linux64/simright
export CALCULIX_CCX_EXE=/home/$username/work/ccx/ccx_2.13

/home/jiechen/.pyenv/shims/python /home/$username/work/gens_libs/unifem_abaqus/tests/test_abaqus_io.py
