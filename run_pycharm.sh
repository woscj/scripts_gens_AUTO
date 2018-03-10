#!/bin/sh

username=`whoami`

export PYTHONPATH=/home/$username/work/gens_libs/meshgen/py/dist/
export LD_LIBRARY_PATH=/home/$username/work/gens_libs/meshgen/lib/linux64/3rdparty/:/home/$username/work/gens_libs/meshgen/lib/linux64/simright
export CALCULIX_CCX_EXE=/home/$username/work/ccx/ccx_2.13

bash /home/woscj607/Downloads/pycharm-community-2017.3.3/bin/pycharm.sh
