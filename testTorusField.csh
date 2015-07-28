# Running
# -------

# vertex position, cm
set x = 50;
set y = 60;
set z = 300;


set stdPos   = " (45 deg, 70.7107 cm, 300 cm)"
set stdField = " (-1.00466, 0.861871, -0.3861) tesla"

echo

# ftof gcard
rm -f ftof.gcard
wget http://jlab.org/12gev_phys/packages/gcards/ftof.gcard >& /dev/null

# running gemc
rm -f logTorusRunning
./gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -BEAM_P="pi-, 5*GeV, 20*deg, 0*deg" -BEAM_V="($x, $y, $z)cm" -N=1 ftof.gcard -FIELD_VERBOSITY=99 >& logTorusRunning

set thisPos   = `grep "Track position in magnetic field (phi, r, z)" logTorusRunning | awk -F:       '{print $2}'`
set thisField = `grep "Field Values (absolute) (Bx, By, Bz)"         logTorusRunning | awk -F"Bz\\)" '{print $2}'`


