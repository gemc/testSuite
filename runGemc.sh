#!/bin/csh

setenv vertex  "$1"
set option='-HALL_FIELD=clas12-newSolenoid -FIELD_VERBOSITY=99 -USE_GUI=0 -N=1'

echo script vertex $vertex


gemc $option -BEAM_V="$vertex" -BEAM_P="e-, 1*GeV, 90*deg 0*deg"


