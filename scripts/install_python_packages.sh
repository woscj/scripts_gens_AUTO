#!/usr/bin/env bash

sudo apt-get install python-pip
sudo apt install libgfortran3

pip install --upgrade pip
pip install enum34 fortranformat msgpack-python py_expression_eval contextlib2
pip install cffi requests==2.13.0 redis
