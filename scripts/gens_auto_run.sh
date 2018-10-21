#!/bin/sh

username=`whoami`

python_path=/home/$username/.pyenv/shims/python

ccx_path=/home/$username/work/ccx/ccx_2.13
gens_path=/home/$username/work/gens_libs
report_path=/home/$username/work/reports

# add system envs
export PYTHONPATH=$gens_path/meshgen/py/dist/
export LD_LIBRARY_PATH=$gens_path/meshgen/lib/linux64/3rdparty/:$gens_path/meshgen/lib/linux64/simright/
export CALCULIX_CCX_EXE=$ccx_path


# add report path
# gens_list="caegen-node topgen-node convgen viewgen-node femily unicad simcmds meshgen"
date=`date +%F`
daily_path=$report_path/$date

if [ ! -d $daily_path ];then
    mkdir $daily_path
else
    rm -rf $daily_path
    mkdir $daily_path
fi

cd $gens_path

# update source code
for i in `ls -F | grep '\/$'`
do
    if [[ -d $i ]];then
        cd $i
        git stash
        git fetch
        diff_master=`git diff master origin/master`
        if [[ -n $diff_master ]]; then
            echo "====================== $i is being updated ===========================" >> $daily_path/update_infos.txt
            echo $diff_s >> $daily_path/update_infos.txt
            git merge
            echo "====================== $i Merge Done ================================="
            if_exist_submodul=`git submodule`
            if [[ -n $if_exist_submodule ]]
            then
                git submodule init
                git submodule update
            fi
            is_meshgen=`echo $i | grep meshgen`
            if [[ -n $is_meshgen ]]
            then
                cd py/dist/pymesher
                $python_path mgmesher_build.py
            fi
            echo -e "\n"
            echo "====================== $i update completed =========================="
            echo -e "\n"
        fi
        cd $gens_path
    fi
done

echo "==================== All code are up to date!!! ========================="
echo -e "\n"
echo "==================== Be ready to run gens automation ===================="
echo -e "\n"

cd $gens_path

for i in `ls -F | grep '\/$'`
do
    if [[ -d $i ]]; then
    cd $i
    echo $i
    for j in `find $gens_path/$i -name test_*.py`
    do
        if [[ -f $j ]]; then
            fn=$(basename $j .py)
            test_dir=$(dirname $j)
            cd $test_dir
            $python_path "$test_dir/$fn.py" 2>&1 | tee -a $daily_path/$fn.txt
            validate_str=`cat $daily_path/$fn.txt | grep OK`
            if [[ -n $validate_str ]]; then
                echo -e "Run $fn Passed\n" >> $daily_path/status.txt
            else
                echo -e "Run $fn Failed\n" >> $daily_path/status.txt
            fi
        fi
    done
    cd $gens_path
    echo -e "\n"
    echo "======================================================================"
    echo -e "\n"
    fi
done

