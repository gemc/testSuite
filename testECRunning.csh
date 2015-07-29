#!/bin/csh -f

set nevents = $1

# ec gcard
rm -f ec.gcard
wget http://jlab.org/12gev_phys/packages/gcards/ec.gcard >& /dev/null


# running gemc and evio2root
foreach r (master branch)
	rm -f logEC$r
	./$r/gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg"  -BEAM_P="e-, 5*GeV, 25*deg, 3*deg" -N=$nevents ec.gcard -NO_FIELD=all -PRINT_EVENT=1 >& logEC$r
	$BANKS/bin/evio2root -INPUTF=out.ev -B=experiments/clas12/ec/ec  >& /dev/null
	mv out.root ec$r.root
	rm out.ev
end

# getting times
set masterTime = `grep "Events only time" logECmaster | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`
set branchTime = `grep "Events only time" logECbranch | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`

echo
echo " > EC Running test for $nevents events"
echo "  >  master time: $masterTime  -  branch time: $branchTime"


#root -l -q ecTest.C | tail -3

