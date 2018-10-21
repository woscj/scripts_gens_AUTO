#!/bin/bash

username=`whoami`
cd /home/$username/work/gens_libs
python_path=/home/$username/.pyenv/shims/python
report_path=/home/$username/work/reports


ccx_path=/home/$username/work/ccx/ccx_2.13
gens_path=/home/$username/work/gens_libs

# add system envs
export PYTHONPATH=$gens_path/meshgen/py/dist/
export LD_LIBRARY_PATH=$gens_path/meshgen/lib/linux64/3rdparty/:$gens_path/meshgen/lib/linux64/simright/
export CALCULIX_CCX_EXE=$ccx_path

date=`date +%F`
daily_path=$report_path/$date

if [ ! -d $daily_path ];then
    mkdir $daily_path
else
    rm -rf $daily_path
    mkdir $daily_path
fi

for i in `ls -F | grep '\/$'`
do
    if [[ -d $i ]]; then
    cd $i
    echo $i
    for j in `find $gens_path/$i -name test_*.py`
    do
        if [[ -f $j ]]; then
            echo $j
            fn=$(basename $j .py)
            test_dir=$(dirname $j)
            echo $test_dir
            cd $test_dir
            echo "$fn.py"
            $python_path "$test_dir/$fn.py" 2>&1 | tee -a $daily_path/$fn.txt
            validate_str=`cat $daily_path/$fn.txt | grep OK`
            if [[ -n $validate_str ]]; then
                echo -e "Run $j Passed\n" >> $daily_path/status.txt
            else
                echo -e "Run $j Failed\n" >> $daily_path/status.txt
            fi
        fi
    done
    cd $gens_path
    echo -e "\n"
    echo "======================================================================"
    echo -e "\n"
    fi
done
