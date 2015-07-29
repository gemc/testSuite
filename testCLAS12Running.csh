#!/bin/csh -f

set nevents = $1

# clas12 gcard
rm -f clas12.gcard
wget http://jlab.org/12gev_phys/packages/gcards/clas12.gcard >& /dev/null

# running gemc and evio2root
foreach r (master branch)
	rm -f logC12$r
	./$r/gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -N=$nevents clas12.gcard -PRINT_EVENT=10 >& logC12$r
	$BANKS/bin/evio2root -INPUTF=out.ev -B=experiments/clas12/pcal/pcal  >& /dev/null
	mv out.root clas12$r.root
	rm out.ev
end

# getting times
set masterTime = `grep "Events only time" logC12master | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`
set branchTime = `grep "Events only time" logC12branch | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`

echo
echo " > Full CLAS12 Running test for $nevents events: PCAL"
echo "  > master time: $masterTime  -  branch time: $branchTime"

root -l -q clas12Test.C | tail -3
