#!/bin/sh

username=`whoami`

cd /home/$username/work/gens_libs/
for i in `ls -F | grep '\/$'`
do
    if [[ -d $i ]]; then
        cd $i
        s=`ls | grep 'setup.py'`
        if [[ -n s ]]; then
            sudo python setup.py develop
        fi
    cd ..
    fi
done
