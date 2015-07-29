#!/bin/csh -f

# vertex position, cm
set x = 5;
set y = 6;
set z = 2;

# ftof gcard
rm -f ctof.gcard
wget http://jlab.org/12gev_phys/packages/gcards/ctof.gcard >& /dev/null

# running gemc
foreach r (master branch)
	rm -f logSolenoid$r
	./$r/gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -BEAM_P="pi-, 5*GeV, 90*deg, 0*deg" -BEAM_V="($x, $y, $z)cm" -N=1 ctof.gcard -FIELD_VERBOSITY=99 -HALL_FIELD=clas12-solenoid >& logSolenoid$r
end

# getting times
set masterTime = `grep "Events only time" logSolenoidmaster | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`
set branchTime = `grep "Events only time" logSolenoidbranch | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`

# getting positions
set masterPos = `grep "Cylindrical: loc. pos. = ($x, $y, $z) cm" logSolenoidmaster | awk -F"tr=" '{print $2}' | awk -F"IT=" '{print $1}'`
set branchPos = `grep "Cylindrical: loc. pos. = ($x, $y, $z) cm" logSolenoidbranch | awk -F"tr=" '{print $2}' | awk -F"IT=" '{print $1}'`

# getting field
set masterField = `grep "Cylindrical: loc. pos. = ($x, $y, $z) cm" logSolenoidmaster | awk -F"B = " '{print $2}'`
set branchFIeld = `grep "Cylindrical: loc. pos. = ($x, $y, $z) cm" logSolenoidbranch | awk -F"B = " '{print $2}'`


echo
echo " > Solenoid test"
echo "  > master time: $masterTime  -  branch time: $branchTime"

if("$masterPos" == "$branchPos") then
	echo "  > Solenoid Position Test: SAME"
else
	echo "  > Solenoid Position Test: $thisPos, standard was $stdPos"
endif

if("$masterField" == "$branchFIeld") then
	echo "  > Solenoid Values Test: SAME"
else
	echo "  > Solenoid Values Test: $thisField, standard was $stdField"
endif

