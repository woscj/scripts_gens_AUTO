#!/bin/sh

username=`whoami`

ccx_path=/home/$username/work/ccx/ccx_2.13
gens_path=/home/$username/work/gens_libs
report_path=/home/$username/work/reports

# add system envs
export PYTHONPATH=$gens_path/meshgen/py/dist/
export LD_LIBRARY_PATH=$gens_path/meshgen/lib/linux64/3rdparty/:$gens_path/meshgen/lib/linux64/simright/
export CALCULIX_CCX_EXE=$ccx_path


which python
which python


# add report path
gens_list="topgen-node viewgen-node"
date=`date +%F`
daily_path=$report_path/$date

mkdir $daily_path


cd $gens_path

echo "==================== All code are up to date!!! ========================="
echo -e "\n"
echo "==================== Be ready to run gens automation ===================="
echo -e "\n"


for i in $gens_list
do
    echo "RUN $i"
    if [ $i == "meshgen" ]; then
        test_path=$gens_path/$i/py/tests
        cd $test_path
    else
        test_path=$gens_path/$i/tests
        cd $test_path
    fi
    echo "======================================================================"
    echo -e "\n"
    for j in `ls | grep -E '^test_(.*)\.py$'`
    do
        echo "==================== Be running $i $j ========================="
       	/home/jiechen/.pyenv/shims/python $test_path/$j 2>&1 | tee -a $daily_path/"$i--$j".txt
        validate_str=`cat $daily_path/"$i--$j".txt | grep OK`
        if [[ -n $validate_str ]]; then
            echo -e "Run $i/$j Passed\n" >> $daily_path/status.txt
        else
            echo -e "Run $i/$j Failed\n" >> $daily_path/status.txt
        fi
    done
    echo -e "\n"
    echo "======================================================================"
    echo -e "\n"
done


