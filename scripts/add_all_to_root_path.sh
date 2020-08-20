#!/bin/sh

username=`whoami`

python_path=/home/$username/.pyenv/versions/simright_pypy3.6-7.2.0/bin/python

cd /home/$username/work/gens_libs/
for i in `ls -F | grep '\/$'`
do
    if [[ -d $i ]]; then
        cd $i
        s=`ls | grep 'setup.py'`
        if [[ -n s ]]; then
            sudo $python_path setup.py develop
        fi
    cd ..
    fi
done
