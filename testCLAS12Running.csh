# Running
# -------

# 2000 events take 24 seconds on my laptop
set nevents      = 200
set standardTime = 90

echo

# clas12 gcard
rm -f clas12.gcard
wget http://jlab.org/12gev_phys/packages/gcards/clas12.gcard >& /dev/null

# running gemc
rm -f logC12Running
./gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -N=$nevents clas12.gcard -PRINT_EVENT=1 >& logC12Running

# check for timing.
set time = `grep "Events only time" logC12Running | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`
@ time -= $standardTime
echo " CLAS12 time test difference: "$time

$BANKS/bin/evio2root -INPUTF=out.ev -B="experiments/clas12/pcal/pcal"  >& /dev/null

mv out.root clas12.root
rm out.ev

#root -l -q clas12Test.C | tail -3

echo
