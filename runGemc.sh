#!/bin/tcsh

source /opt/jlab_software/2.5/ce/jlab.csh keepmine

setenv vertex       "$1"
setenv interpolation $2
setenv field         $3
setenv run           $4

echo
echo Running gemc with:
echo vertex: $vertex
echo interpolation: $interpolation
echo field: $field
echo run: $run
echo


set option = ''
set fprop  = 'clas12-newSolenoid, 1*mm, G4ClassicalRK4, linear'

if ($interpolation == "None") then
	set option = '-HALL_FIELD=clas12-newSolenoid -FIELD_VERBOSITY=99 -USE_GUI=0 -N=1'
	set fprop  = 'clas12-newSolenoid, 1*mm, G4ClassicalRK4, none'
endif

if ($field == "torus") then
	set option = '-HALL_FIELD=TorusSymmetric -FIELD_VERBOSITY=99 -USE_GUI=0 -N=1'
	set fprop  = 'TorusSymmetric, 2*mm, G4ClassicalRK4, linear'

	if ($interpolation == "None") then
		set fprop  = 'TorusSymmetric, 2*mm, G4ClassicalRK4, none'
	endif
endif

if ($field == "c12BinaryTorusSymmSolenoid2018") then
	set option = '-HALL_FIELD=c12BinaryTorusSymmSolenoid2018 -FIELD_VERBOSITY=99 -USE_GUI=0 -N=1'
	set fprop  = 'c12BinaryTorusSymmSolenoid2018, 2*mm, G4ClassicalRK4, linear'

	if ($interpolation == "None") then
		set fprop  = 'c12BinaryTorusSymmSolenoid2018, 2*mm, G4ClassicalRK4, none'
	endif
endif


if ($field == "c12BinaryTorusASymmSolenoid2018") then
	set option = '-HALL_FIELD=c12BinaryTorusASymmSolenoid2018 -FIELD_VERBOSITY=99 -USE_GUI=0 -N=1'
	set fprop  = 'c12BinaryTorusASymmSolenoid2018, 2*mm, G4ClassicalRK4, linear'

	if ($interpolation == "None") then
		set fprop  = 'c12BinaryTorusASymmSolenoid2018, 2*mm, G4ClassicalRK4, none'
	endif
endif

if ( $run == "no") then
	gemc -USE_GUI=0 $option -BEAM_V="$vertex" -BEAM_P="e-, 1*GeV, 90*deg 0*deg"  -FIELD_PROPERTIES="$fprop"
else
	gemc -USE_GUI=0 $option -BEAM_V="$vertex" -BEAM_P="e-, 1*GeV, 90*deg 0*deg"  -FIELD_PROPERTIES="$fprop"
endif
