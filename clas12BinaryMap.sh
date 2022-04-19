#!/bin/zsh

# example:
#
# ./clas12Maps.sh Linear

if [ "$#" -ne 2 ]; then
	echo " "       >&2
	echo " Usage:" >&2
	echo " "       >&2
	echo  " $0 interpolation field"  >&2
	echo " "       >&2
	echo " interpolation: <None> or <Linear>"  >&2
	echo " field: <c12BinaryTorusSymmSolenoid2018> or <c12BinaryTorusASymmSolenoid2018>"       >&2
	echo " "       >&2
	exit 1
fi

interpolation=$1

if [[ $interpolation != "None" && $interpolation != "Linear" ]]; then
	echo " interpolation: <None> or <Linear>"  >&2
	exit 1
fi

field=$2

if [[ $field != "c12BinaryTorusSymmSolenoid2018" && $field != "c12BinaryTorusASymmSolenoid2018" ]]; then
	echo " field: <c12BinaryTorusSymmSolenoid2018> or <c12BinaryTorusASymmSolenoid2018>"       >&2
	exit 1
fi

ngreps=1
fileNamePoints=$field$interpolation".txt"
fileNameL=gemcLog$fileNamePoints
fileNameG=gemc$fileNamePoints
rm -f $fileNameG ; touch $fileNameG
rm -f $fileNameL ; touch $fileNameL


echo
echo Interpolation: $interpolation
echo Field: $field
echo FileName with Requested Vertex Points: $fileNamePoints
echo FileName with Gemc Log: $fileNameG
echo FileName with Gemc Results: $fileNameG
echo

# units in mm

npoints=10

minX=1
maxX=5000
minY=1
maxY=5000
minZ=-3000
maxZ=3000

xvalues=(${(f)"$(jot -r $npoints $minX $maxX)"})
yvalues=(${(f)"$(jot -r $npoints $minY $maxY)"})
zvalues=(${(f)"$(jot -r $npoints $minZ $maxZ)"})


#rm -f $fileNamePoints ; touch $fileNamePoints
for i in {1..$npoints}
do
	# decimal points
	decimal=(${(f)"$(jot -r 3 0 1000)"})
	#echo "("$xvalues[$i]"."$decimal[1]", "$yvalues[$i]"."$decimal[2]", "$zvalues[$i]"."$decimal[3]")mm" >> $fileNamePoints
done

vertex=(${(f)"$(cat $fileNamePoints)"})

# first output the options in the file just to make sure.
echo running gemc once to check parameters with options $vertex[1] $interpolation $field no
echo
./runGemc.sh $vertex[1] $interpolation $field no | grep -A7 "> Magnetic Field"

echo Now running gemc for each point:
for i in {1..$npoints}
do
	echo vertex $vertex[$i] $interpolation $field
	./runGemc.sh $vertex[$i] $interpolation $field yes | grep -A$ngreps "Track position in magnetic field map," >> $fileNameG
done


