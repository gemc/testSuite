# Running
# -------

# vertex position, cm
set x = 5;
set y = 6;
set z = 2;

set stdTime  =  2 # 22 seconds to read the map
set stdPos   = "7.81025cm, long=2cm, phi=50.1944,"
set stdField = "(-0.736212, -0.883454, 50006.5) gauss"

echo

# ftof gcard
rm -f ctof.gcard
wget http://jlab.org/12gev_phys/packages/gcards/ctof.gcard >& /dev/null

# running gemc
rm -f logSolenoidRunning
./gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -BEAM_P="pi-, 5*GeV, 90*deg, 0*deg" -BEAM_V="($x, $y, $z)cm" -N=1 ctof.gcard -FIELD_VERBOSITY=99 -HALL_FIELD=clas12-solenoid >& logSolenoidRunning

set thisPos   = `grep "Cylindrical: loc. pos. = (5, 6, 2) cm" logSolenoidRunning | awk -F"tr="       '{print $2}' | awk -F"IT=" '{print $1}'`
set thisField = `grep "Cylindrical: loc. pos. = (5, 6, 2) cm" logSolenoidRunning | awk -F"B = " '{print $2}'`


if("$stdPos" == "$thisPos") then
	echo Solenoid Position Test: SAME
else
	echo Solenoid Position Test: $thisPos, standard was $stdPos
endif

if("$stdField" == "$thisField") then
	echo Solenoid Values Test: SAME
else
	echo Solenoid Values Test: $thisField, standard was $stdField
endif

# check for timing.
set time = `grep "Total gemc time" logSolenoidRunning | awk -F"Total gemc time:" '{print $2}' | awk -F. '{print $1}'`
@ time -= $stdTime
echo "Solenoid time test difference: "$time

echo
