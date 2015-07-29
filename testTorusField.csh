# Running
# -------

# vertex position, cm
set x = 50;
set y = 60;
set z = 300;

set stdTime  =  22 # 22 seconds to read the map
set stdPos   = "(50.1944 deg, 78.1025 cm, 300 cm)"
set stdField = "(-0.894079, 0.68461, -0.20967) tesla"

echo

# ftof gcard
rm -f ftof.gcard
wget http://jlab.org/12gev_phys/packages/gcards/ftof.gcard >& /dev/null

# running gemc
rm -f logTorusRunning
./source/gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -BEAM_P="pi-, 5*GeV, 20*deg, 0*deg" -BEAM_V="($x, $y, $z)cm" -N=1 ftof.gcard -FIELD_VERBOSITY=99 >& logTorusRunning

set thisPos   = `grep "Track position in magnetic field (phi, r, z)" logTorusRunning | awk -F:       '{print $2}'`
set thisField = `grep "Field Values (absolute) (Bx, By, Bz)"         logTorusRunning | awk -F"Bz\\)" '{print $2}'`


if("$stdPos" == "$thisPos") then
	echo Torus Position Test: SAME
else
	echo Torus Position Test: $thisPos, standard was $stdPos
endif

if("$stdField" == "$thisField") then
	echo Torus Values Test: SAME
else
	echo Torus Values Test: $thisField, standard was $stdField
endif

# check for timing.
set time = `grep "Total gemc time" logTorusRunning | awk -F"Total gemc time:" '{print $2}' | awk -F. '{print $1}'`
@ time -= $stdTime
echo "Torus time test difference: "$time

echo
