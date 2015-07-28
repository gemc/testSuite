# Running
# -------

# 2000 events take 24 seconds on my laptop
set nevents      = 100
set standardTime = 60

echo

# clas12 gcard
rm -f clas12.gcard
wget http://jlab.org/12gev_phys/packages/gcards/clas12.gcard >& /dev/null

# running gemc
rm -f logC12Running
./gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -N=$nevents ftof.gcard -NO_FIELD=all -PRINT_EVENT=100 >& logECRunning

# check for timing.
set time = `grep "Events only time" logC12Running | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`
@ time -= $standardTime
echo " CLAS12 time test difference: "$time

$BANKS/bin/evio2root -INPUTF=out.ev -B="experiments/clas12/ftof/ftof  experiments/clas12/pcal/pcal"  >& /dev/null

mv out.root clas12.root
rm out.ev

root -l -q clas12Test.C | tail -3

echo
