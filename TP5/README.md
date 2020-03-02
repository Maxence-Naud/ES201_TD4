1/ cp -v test_omp /your/directory
2/ export GEM5=/home/g/gbusnot/ES201/tools/TP5/gem5-stable
3/ $GEM5/build/ARM/gem5.fast $GEM5/configs/example/se.py ....


Q2 : 
Paramètres choisis :
- decodeWidth
- issueWidth
- commitWidth
- numPhysIntRegs
- numPhysFloatRegs

Autres paramètres potentiels :
- trapLatency
- LSQDepCheckShift
- fetchWidth



Q3 : /home/g/gbusnot/ES201/tools/TP5/gem5-stable/configs/common


Q4 :
$GEM5/build/ARM/gem5.fast $GEM5/configs/example/se.py --caches --cpu-type=<TYPE> -n <NBTHREAD> -c test_omp -o "<NBTHREAD> <TAILLEMATRICE>"


Q5 :
Valeurs intéressantes à regarder :
sim_insts (pour Q7)
system.cpu0.numCycles (ou system.cpu.numCycles si un seul thread)
 
