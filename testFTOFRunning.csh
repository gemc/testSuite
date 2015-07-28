# Running
# -------

# 2000 events take 24 seconds on my laptop
set nevents      = 5000
set standardTime = 60

echo

# ftof gcard
rm ftof.gcard
wget http://jlab.org/12gev_phys/packages/gcards/ftof.gcard >& /dev/null

# running gemc
rm logFTOFRunning
./gemc -USE_GUI=0 -SPREAD_P="0.0*GeV, 0*deg, 0*deg" -N=$nevents ftof.gcard -NO_FIELD=all -PRINT_EVENT=100 >& logFTOFRunning

# check for timing. For 2000 events it should be 24 seconds.
set time = `grep "Events only time" logFTOFRunning | awk -F"Events only time:" '{print $2}' | awk -F. '{print $1}'`
@ time -= $standardTime
echo " FTOF test deviation: "$time

$BANKS/bin/evio2root -INPUTF=out.ev -B=experiments/clas12/ftof/ftof  >& /dev/null

mv out.root ftof.root
rm out.ev

root -l -q ftofTest.C | tail -3

echo
