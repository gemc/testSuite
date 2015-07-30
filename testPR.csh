#!/bin/csh -f


# This script will clone the gemc master repo and a branch (first argument of the script)
# and perform a series of comparisons between the master and the branch.
#
# The test is run in the gemcTest/test subdirs "master" and "branch"
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

set master = https://github.com/gemc/source.git
set branch = $1


rm -rf gemcTest; mkdir gemcTest ; cd gemcTest

# getting test suite
git clone https://github.com/gemc/test.git >& /dev/null
cd test

echo
echo " > Running tests on $OSRELEASE"
echo
echo > result.txt
echo " > Running tests on $OSRELEASE" >> result.txt

# compilation
echo " > Running compilation test..."
git clone $master master >& /dev/null
git clone $branch branch>& /dev/null

./testCompilation.csh >> result.txt

# getting and unpacking clas12 geometry
wget http://jlab.org/12gev_phys/packages/gcards/experiments-devel.tar >& /dev/null
tar xpvf experiments-devel.tar >& /dev/null
rm experiments-devel.tar

echo " > Testing clas12 ftof running..."
./testFTOFRunning.csh 5000 | grep -v "0+0" >> result.txt
echo " > Testing clas12 ec running..."
./testECRunning.csh  2000   | grep -v "0+0" >> result.txt
echo " > Testing clas12 running..."
./testCLAS12Running.csh 2000 | grep -v "0+0" >> result.txt
echo " > Testing clas12 solenoid..."
./testSolenoidField.csh >> result.txt
echo " > Testing clas12 torus..."
./testTorusField.csh    >> result.txt
echo "... done!"
echo
echo >> result.txt
echo >> result.txt























