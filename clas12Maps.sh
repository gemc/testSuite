#!/bin/zsh

if [ "$#" -ne 2 ]; then
	echo " "       >&2
	echo " Usage:" >&2
	echo " "       >&2
	echo  " $0 interpolation field"  >&2
	echo " "       >&2
	echo " interpolation: <None> or <Linear>"  >&2
	echo " field: <solenoid> or <torus>"       >&2
	echo " "       >&2
	exit 1
fi

interpolation=$1
field=$2

ngreps=1

echo
echo Interpolation: $interpolation
echo Field: $field
echo

# units in mm

npoints=100

minX=1
maxX=5000
minY=1
maxY=5000
minZ=-3000
maxZ=3000

if [[ $field == "torus" ]]; then
	minX=1
	maxX=5000
	minY=1
	maxY=5000
	minZ=1000
	maxZ=6000
	ngreps=4
	echo "torus field map"
fi



xvalues=(${(f)"$(jot -r $npoints $minX $maxX)"})
yvalues=(${(f)"$(jot -r $npoints $minY $maxY)"})
zvalues=(${(f)"$(jot -r $npoints $minZ $maxZ)"})

fileNamePoints=$field$interpolation

rm -f $fileNamePoints.txt ; touch $fileNamePoints.txt

for i in {1..$npoints}
do
	# decimal points
	decimal=(${(f)"$(jot -r 3 0 1000)"})
	echo "("$xvalues[$i]"."$decimal[1]", "$yvalues[$i]"."$decimal[2]", "$zvalues[$i]"."$decimal[3]")mm" >> $fileNamePoints.txt
done

vertex=(${(f)"$(cat $fileNamePoints.txt)"})

fileNameG=gemc$fileNamePoints
fileNameL=gemcLog$fileNamePoints

rm -f $fileNameG.txt ; touch $fileNameG.txt
rm -f $fileNameL.txt ; touch $fileNameL.txt

# first output the options in the file just to make sure. Do not run gemc
./runGemc.sh $vertex[$i] $interpolation $field no | grep -A7 "> Magnetic Field" >> $fileNameL.txt

for i in {1..$npoints}
do
	echo vertex $vertex[$i] $interpolation $field
	./runGemc.sh $vertex[$i] $interpolation $field yes | grep -A$ngreps "Track position in magnetic field map," >> $fileNameG.txt
done


