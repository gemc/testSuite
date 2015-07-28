#!/bin/csh -f


# This script will clone a fork or branch (first argument of the script)
# and perform a series of tests:.
#
# The test is run in a gemcTest directory
# The results are stored in result.txt
#
#
# > Compilation:
#   - check for no errors
#   - check for no warnings
#
# > Running:
#   - clas12 ftof only, no field: speed and efficiency.
#   - clas12 ec only, no field: speed and efficiency.
#   - clas12 full, with fields: speed and efficiency.
#
# > Fields:
#   - clas12 torus value at 4 points
#   - clas12 solenoid value at 4 points
#

set branch    = $1
set minNcores = 15

rm -rf gemcTest
mkdir  gemcTest
cd     gemcTest

touch result.txt

./testCompilation.csh >> result.txt

# getting and unpacking clas12 geometry
wget http://jlab.org/12gev_phys/packages/gcards/experiments-devel.tar
tar xpvf experiments-devel.tar

./testFTOFRUnning.csh >> result.txt

























