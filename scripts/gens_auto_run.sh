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
        git fetch
        diff_s=`git diff master origin/master`
        if [[ -n $diff_s ]]; then
            echo "====================== $i is being updated ===========================" >> $daily_path/update_infos.txt
            echo $diff_s >> $daily_path/update_infos.txt
            mergeStatus=`git merge | grep Aborting`
            if [[ -n $mergeStatus ]];then
                rm -rf $i
                cd ..
                git clone git@github.com:simright/$i
            fi
            s=`echo $i | grep meshgen`
            if [[ -n $s ]]
            then
		        git submodule init
                git submodule update
                cd py/dist/pymesher
                $python_path mgmesher_build.py
            fi
            m=`git submodule`
            if [[ -n $m ]]
            then
                git submodule init
                git submodule update
            fi
            echo -e "\n"
            echo "======================================================================"
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

#for i in $gens_list
for i in `ls -F | grep '\/$'`
do
#    echo "RUN $i"
    gens_dir=${i%/*}
    if [ $gens_dir == "meshgen" ]; then
        echo "RUN $i"
        test_path=$gens_path/$gens_dir/py/tests
        cd $test_path
    else
	echo "RUN $i"
        if [ ! -d "$gens_path/$gens_dir/tests" ];then
            continue
	else
	    test_path=$gens_path/$gens_dir/tests
        fi
        cd $test_path
    fi
    echo "======================================================================"
    echo -e "\n"
    for j in `ls | grep -E '^test_(.*)\.py$'`
    do
        echo "==================== Be running $i $j ========================="
        python $test_path/$j 2>&1 | tee -a $daily_path/"$gens_dir--$j".txt
        validate_str=`cat $daily_path/"$gens_dir--$j".txt | grep OK`
        if [[ -n $validate_str ]]; then
            echo -e "Run $gens_dir/$j Passed\n" >> $daily_path/status.txt
        else
            echo -e "Run $gens_dir/$j Failed\n" >> $daily_path/status.txt
        fi
    done
    echo -e "\n"
    echo "======================================================================"
    echo -e "\n"
done


