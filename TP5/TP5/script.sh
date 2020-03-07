#!/bin/bash
rm result_exe_4.txt
for (( k=1; k <= 32; k =k*2 ));
do
	echo "m = ${k}" >> result_exe_4.txt
	for (( i=1; i <= k; i =i*2 ));
	do
		echo "${i} threads" >> result_exe_4.txt
		$GEM5/build/ARM/gem5.fast $GEM5/configs/example/se.py -n ${i} -w $1 --caches --cpu-type=detailed -c test_omp -o "${i} ${k}" | grep -i "Done" >> result_exe_4.txt
		cat ./m5out/stats.txt | grep -e "system.cpu.numCycles" -e "system.cpu0.numCycles" -e "system.cpu00.numCycles" >> result_exe_4.txt
		cat ./m5out/stats.txt | grep -i "sim_inst" >> result_exe_4.txt
	done
done
