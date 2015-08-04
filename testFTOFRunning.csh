#!/bin/csh -f

set nevents = $1

# ftof gcard
rm -f ftof.gcard
wget http://jlab.org/12gev_phys/packages/gcards/ftof.gcard >& /dev/null

# running gemc and evio2root
foreach r (master branch)
	rm -f logFTOF$r
	./$r/gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -N=$nevents ftof.gcard -HALL_FIELD=clas12-solenoid -PRINT_EVENT=200 >& logFTOF$r
	$BANKS/bin/evio2root -INPUTF=out.ev -B=experiments/clas12/ftof/ftof  >& /dev/null
	mv out.root ftof$r.root
	rm out.ev
end

# getting times
set masterTime = `grep "Events only time" logFTOFmaster | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`
set branchTime = `grep "Events only time" logFTOFbranch | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`

echo
echo " > FTOF Running test for $nevents events"
echo "  > master time: $masterTime  -  branch time: $branchTime"

root -l -q ftofTest.C | tail -3

