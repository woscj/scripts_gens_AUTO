#!/bin/sh

username=`whoami`

ccx_path=/home/$username/work/ccx/ccx_2.13
gens_path=/home/$username/work/gens_libs
report_path=/home/$username/work/reports

# add system envs
export PYTHONPATH=$gens_path/meshgen/py/dist/
export LD_LIBRARY_PATH=$gens_path/meshgen/lib/linux64/3rdparty/:$gens_path/meshgen/lib/linux64/simright/
export CALCULIX_CCX_EXE=$ccx_path


cd $gens_path

# make sure the branch is on master
# for i in `ls -F | grep '\/$'`
# do
#     if [[ -d $i ]];then
#         cd $i
#         echo "============== Checkout all branch back master ======================="
#         status_s=`git status`
#         is_on_master=`head -1 $status_s | grep "master"`
#         if [[ -n $is_on_master ]];then
#             cd ..
#             continue
#         else
#             git checkout master
#         fi
#         cd $gens_path
#     fi
# done

# update source code
for i in `ls -F | grep '\/$'`
do
    if [[ -d $i ]];then
        cd $i
        git fetch
        diff_s=`git diff master origin/master`
        if [[ -n $diff_s ]]; then
            echo "====================== $i is being updated ==========================="
            git merge
            s=`echo $i | grep meshgen`
            if [[ -n $s ]]
            then
                git submodule update
                cd py/dist/pymesher
                python mgmesher_build.py
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

gens_list="caegen-node topgen-node convgen viewgen-node viewgen"
date=`date +%F`
daily_path=$report_path/$date

mkdir $daily_path

for i in $gens_list
do
    echo "RUN $i"
    touch $daily_path/$i.txt
    cd $gens_path/$i/tests
    echo "======================================================================"
    echo -e "\n"
    py_file_name=`ls | grep -E '^test_(.*)\.py$'`
    python $gens_path/$i/tests/$py_file_name 2>&1 | tee -a $daily_path/$i.txt
    validate_str=`tail -1 $daily_path/$i.txt | grep OK`
    if [[ -n $validate_str ]]; then
    echo -e "Run $i Passed\n" >> $daily_path/status.txt
    else
    echo -e "Run $i Failed\n" >> $daily_path/status.txt 
    fi
    echo -e "\n"
    echo "======================================================================"
    echo -e "\n"
done


