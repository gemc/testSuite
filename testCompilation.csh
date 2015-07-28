#!/bin/csh -f

# > Compilation:
#   - check for no errors
#   - check for no warnings

set minNcores = 15

cd source
scons -j$minNcores OPT=1 | grep -v Compiling >& testCompilation
if( -f gemc) then
	echo Compilation: PASSED
endif
if(`grep warning testCompilation | wc | awk '{print $1}' != 0`) then
	echo Warnings: WARNINGS
else
	echo Warnings: NO WARNINGS
endif

cd ..
