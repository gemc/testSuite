#!/bin/zsh


#if [ "$#" -ne 1 ]; then
#	echo " "       >&2
#	echo " Usage:" >&2
#	echo " "       >&2
#	echo  " $0 Number of points"  >&2
#	echo " "       >&2
#	exit 1
#fi

# units in mm

npoints=100

minX=1
maxX=5000
minY=1
maxY=5000
minZ=-3000
maxZ=3000

xvalues=(${(f)"$(jot -r $npoints $minX $maxX)"})
yvalues=(${(f)"$(jot -r $npoints $minY $maxY)"})
zvalues=(${(f)"$(jot -r $npoints $minZ $maxZ)"})

rm -f solenoidPoints.txt ; touch solenoidPoints.txt

for i in {1..$npoints}
do
	# decimal points
	decimal=(${(f)"$(jot -r 3 0 1000)"})
	echo "("$xvalues[$i]"."$decimal[1]", "$yvalues[$i]"."$decimal[2]", "$zvalues[$i]"."$decimal[3]")mm" >> solenoidPoints.txt
done

vertex=(${(f)"$(cat solenoidPoints.txt)"})

rm -f gemcSolenoidPoints.txt ; touch gemcSolenoidPoints.txt

for i in {1..$npoints}
do
	echo vertex $vertex[$i]
	./runGemc.sh $vertex[$i] | grep -A1 "Track position in magnetic field map," >> gemcSolenoidPoints.txt
done


