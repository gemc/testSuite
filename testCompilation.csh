#!/bin/csh -f

# > Compilation:
#   - check for no errors
#   - check for no warnings

set ncpu = 1
if(`uname` == "Darwin") set ncpu = `sysctl -a hw | grep activecpu | awk '{print $2}'`
if(`uname` == "Linux")  set ncpu = `grep processor /proc/cpuinfo | wc | awk '{print $1}'`
set opt = " -j"$ncpu" OPT=1"


cd master
scons $opt | grep -v Compiling >& testCompilation
cd ../branch
scons $opt | grep -v Compiling >& testCompilation

echo
echo " > Compilation test"
echo "  > Compilation options: $opt"

if( -f gemc) then
	echo "  > Compilation: PASSED"
endif
if(`grep warning testCompilation | wc | awk '{print $1}'` != 0) then
	echo "  > Warnings: WARNINGS"
else
	echo "  > Warnings: NO WARNINGS"
endif

cd ..
