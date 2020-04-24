#!/bin/csh


setenv vertex        "$1"
setenv interpolation $2
setenv field         $3
setenv run           $4



set option = '-HALL_FIELD=clas12-newSolenoid -FIELD_VERBOSITY=99 -USE_GUI=0 -N=1'
set fprop  = 'clas12-newSolenoid, 1*mm, G4ClassicalRK4, linear'

if ($interpolation == "none") then
	set fprop  = 'clas12-newSolenoid, 1*mm, G4ClassicalRK4, none'
endif

if ($field == "torus") then
	echo fieldmap: torus
	set option = '-HALL_FIELD=TorusSymmetric -FIELD_VERBOSITY=99 -USE_GUI=0 -N=1'
	set fprop  = 'TorusSymmetric, 2*mm, G4ClassicalRK4, linear'

	if ($interpolation == "none") then
		set fprop  = 'TorusSymmetric, 2*mm, G4ClassicalRK4, none'
	endif
endif



if ( $run == "no") then
	echo script vertex $vertex interpolation: $interpolation $field option $option field properties: "$fprop"
	gemc $option -BEAM_V="$vertex" -BEAM_P="e-, 1*GeV, 90*deg 0*deg" -FIELD_PROPERTIES="$fprop"
else
	gemc $option -BEAM_V="$vertex" -BEAM_P="e-, 1*GeV, 90*deg 0*deg" -FIELD_PROPERTIES="$fprop"
endif
