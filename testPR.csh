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
#   - clas12 torus value (1 point)
#   - clas12 solenoid value at 4 points
#

set branch    = $1
set minNcores = 15

rm -rf gemcTest
mkdir  gemcTest
cd     gemcTest


./testCompilation.csh > result.txt

# getting and unpacking clas12 geometry
wget http://jlab.org/12gev_phys/packages/gcards/experiments-devel.tar
tar xpvf experiments-devel.tar

./testFTOFRunning.csh   | grep -v "0+0" >> result.txt
./testECRunning.csh     | grep -v "0+0" >> result.txt
./testSolenoidField.csh | grep -v "0+0" >> result.txt
./testTorusField.csh    | grep -v "0+0" >> result.txt
./testCLAS12Running.csh | grep -v "0+0" >> result.txt

























