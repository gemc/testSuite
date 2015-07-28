# Running
# -------

# 2000 events take 24 seconds on my laptop
set nevents      = 5000
set standardTime = 60

echo

# ec gcard
rm ec.gcard
wget http://jlab.org/12gev_phys/packages/gcards/ec.gcard >& /dev/null

# running gemc
rm logECRunning
./gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -N=$nevents ec.gcard -NO_FIELD=all -PRINT_EVENT=100 >& logECRunning

# check for timing. For 2000 events it should be 24 seconds.
set time = `grep "Events only time" logECRunning | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`
@ time -= $standardTime
echo " EC test deviation: "$time

$BANKS/bin/evio2root -INPUTF=out.ev -B=experiments/clas12/ec/ec  >& /dev/null

mv out.root ec.root
rm out.ev

root -l -q ecTest.C | tail -3

echo
