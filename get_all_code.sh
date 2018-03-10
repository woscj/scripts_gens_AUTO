#!/bin/sh

username=`whoami`

report_path="/home/$username/work/reports"
gens_path="/home/$username/work/gens_libs"

# create dir

mkdir $report_path
mkdir $gens_path

# get all source codes
cd $gens_path

# apt-get install git
git clone git@github.com:simright/caegen-node.git &&
git clone git@github.com:simright/convgen.git &&
git clone git@github.com:simright/fem_utils.git &&
git clone git@github.com:simright/femily.git &&
git clone git@github.com:simright/meshgen.git &&
git clone git@github.com:simright/pycg3d.git &&
git clone git@github.com:simright/pyfem_abaqus.git &&
git clone git@github.com:simright/pyfem_ansys.git &&
git clone git@github.com:simright/pyfem_aster.git &&
git clone git@github.com:simright/pyfem_calculix.git &&
git clone git@github.com:simright/pyfem_dyna.git &&
git clone git@github.com:simright/pyfem_hypermesh.git &&
git clone git@github.com:simright/pyfem_json.git &&
git clone git@github.com:simright/pyfem_nastran.git &&
git clone git@github.com:simright/pyfem_optistruct.git &&
git clone git@github.com:simright/pyfemx.git &&
git clone git@github.com:simright/pymatx.git &&
git clone git@github.com:simright/pyunitx.git &&
git clone git@github.com:simright/pyviewdata.git &&
git clone git@github.com:simright/sim_modeler.git &&
git clone git@github.com:simright/simcmds.git &&
git clone git@github.com:simright/topgen-node.git &&
git clone git@github.com:simright/unicad.git &&
git clone git@github.com:simright/unifem.git &&
git clone git@github.com:simright/unifem_abaqus.git &&
git clone git@github.com:simright/unifem_ansys.git &&
git clone git@github.com:simright/unifem_aster.git &&
git clone git@github.com:simright/unifem_calculix.git &&
git clone git@github.com:simright/unifem_dyna.git &&
git clone git@github.com:simright/unifem_json.git &&
git clone git@github.com:simright/unifem_nastran.git &&
git clone git@github.com:simright/unifem_optistruct.git &&
git clone git@github.com:simright/unimesh.git &&
git clone git@github.com:simright/viewgen-node.git &&
git clone git@github.com:simright/unires_sipesc.git &&
git clone git@github.com:simright/unires.git &&
git clone git@github.com:simright/unires_calculix.git &&
git clone git@github.com:simright/pyfem_sipesc.git &&
git clone git@github.com:simright/pyworker.git &&
git clone git@github.com:simright/viewgen.git

