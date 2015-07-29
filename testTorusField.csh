#!/bin/csh -f

# vertex position, cm
set x = 50;
set y = 60;
set z = 300;

# ftof gcard
rm -f ftof.gcard
wget http://jlab.org/12gev_phys/packages/gcards/ftof.gcard >& /dev/null

# running gemc
foreach r (master branch)
rm -f logTorus$r
	./$r/gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -BEAM_P="pi-, 5*GeV, 90*deg, 0*deg" -BEAM_V="($x, $y, $z)cm" -N=1 ftof.gcard -FIELD_VERBOSITY=99 >& logTorus$r
end

# getting times
set masterTime = `grep "Events only time" logTorusmaster | awk -F"Total gemc time:" '{print $2}' | awk -Fseconds '{print $1}'`
set branchTime = `grep "Events only time" logTorusbranch | awk -F"Total gemc time:" '{print $2}' | awk -Fseconds '{print $1}'`

# getting positions
set masterPos = `grep "Track position in magnetic field (phi, r, z)" logTorusmaster | awk -F:       '{print $2}'`
set branchPos = `grep "Track position in magnetic field (phi, r, z)" logTorusbranch | awk -F:       '{print $2}'`

# getting field
set masterField = `grep "Field Values (absolute) (Bx, By, Bz)" logTorusmaster | awk -F"Bz\\)" '{print $2}'`
set branchFIeld = `grep "Field Values (absolute) (Bx, By, Bz)" logTorusbranch | awk -F"Bz\\)" '{print $2}'`


echo
echo " > Torus test"
echo "  > master time: $masterTime  -  branch time: $branchTime"

if("$masterPos" == "$branchPos") then
	echo "  > Torus Position Test: SAME"
else
	echo "  > Torus Position Test: $thisPos, standard was $stdPos"
endif

if("$masterField" == "$branchFIeld") then
	echo "  > Torus Values Test: SAME"
else
	echo "  > Torus Values Test: $thisField, standard was $stdField"
endif


