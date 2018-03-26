#!/usr/bin/env bash

username=`whoami`

export PYTHONPATH=/home/$username/work/gens_libs/meshgen/py/dist/
export LD_LIBRARY_PATH=/home/$username/work/gens_libs/meshgen/lib/linux64/3rdparty/:/home/$username/work/gens_libs/meshgen/lib/linux64/simright
export CALCULIX_CCX_EXE=/home/$username/work/ccx/ccx_2.13


simcmds_path=/home/$username/work/gens_libs/meshgen
cd $simcmds_path
echo $simcmds_path
echo `which python`
cd py/tests
for i in `ls | grep -E '^test_(.*)\.py$'`
do
    echo $i
    /home/jiechen/.pyenv/shims/python $simcmds_path/py/tests/$i
done
