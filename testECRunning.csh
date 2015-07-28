# Running
# -------

# 2000 events take 24 seconds on my laptop
set nevents      = 1000
set standardTime = 60

echo

# ec gcard
rm -f ec.gcard
wget http://jlab.org/12gev_phys/packages/gcards/ec.gcard >& /dev/null

# running gemc
rm -f logECRunning
./gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -BEAM_P="pi-, 5*GeV, 25*deg, 3*deg"  -N=$nevents ec.gcard -NO_FIELD=all -PRINT_EVENT=1 >& logECRunning

# check for timing.
set time = `grep "Events only time" logECRunning | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`
@ time -= $standardTime
echo " EC time test difference: "$time

$BANKS/bin/evio2root -INPUTF=out.ev -B=experiments/clas12/ec/ec  >& /dev/null

mv out.root ec.root
rm out.ev

#root -l -q ecTest.C | tail -3

echo
