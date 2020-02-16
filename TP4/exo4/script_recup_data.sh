
echo simu/simu_blowfish.out > result_prof.txt
grep -A 8 "sim_inst_class_prof.start_dist" simu/simu_blowfish.out >> result_prof.txt
echo simu/simu_dijkstra.out >> result_prof.txt
grep -A 8 "sim_inst_class_prof.start_dist" simu/simu_dijkstra.out >> result_prof.txt

echo "Study L1 cache size Cortex A7 -- blowfish" > result_A7.txt
echo "CL1_size;nb_cycles;IPC;CPI;IL1_mr;DL1_mr;UL2_mr;bpred_dir_pr;ifq_rate;ifq_full;RUU_rate;RUU_full;LSQ_rate;LSQ_full" >> result_A7.txt
echo "Study L1 cache size Cortex A15 -- blowfish" > result_A15.txt
echo "CL1_size;nb_cycles;IPC;CPI;IL1_mr;DL1_mr;UL2_mr;bpred_dir_pr;ifq_rate;ifq_full;RUU_rate;RUU_full;LSQ_rate;LSQ_full" >> result_A15.txt

for SIZE_CL1 in 16 32 64 128 256
do
	FILEA7="simu/simu_blowfish_A7_CL1_${SIZE_CL1}.out"
	FILEA15="simu/simu_blowfish_A15_CL1_${SIZE_CL1}.out"
	LINEA7="${SIZE_CL1}"
	LINEA15="${SIZE_CL1}"
	for D in sim_cycle sim_IPC sim_CPI il1.miss_rate dl1.miss_rate ul2.miss_rate bpred_dir_rate ifq_rate ifq_full ruu_rate ruu_full lsq_rate lsq_full
	do
		LINEA7+=";`grep ${D} $FILEA7 | cut -d# -f1 | sed -e "s/[a-z0-9._]*${D}//g" -e "s/ //g"`"
		LINEA15+=";`grep ${D} $FILEA15 | cut -d# -f1 | sed -e "s/[a-z0-9._]*${D}//g" -e "s/ //g"`"
	done
	echo $LINEA7 >> result_A7.txt
	echo $LINEA15 >> result_A15.txt
done

echo "Study L1 cache size Cortex A7 -- dijkstra" >> result_A7.txt
echo "CL1_size;nb_cycles;IPC;CPI;IL1_mr;DL1_mr;UL2_mr;bpred_dir_pr;ifq_rate;ifq_full;RUU_rate;RUU_full;LSQ_rate;LSQ_full" >> result_A7.txt
echo "Study L1 cache size Cortex A15 -- dijkstra" >> result_A15.txt
echo "CL1_size;nb_cycles;IPC;CPI;IL1_mr;DL1_mr;UL2_mr;bpred_dir_pr;ifq_rate;ifq_full;RUU_rate;RUU_full;LSQ_rate;LSQ_full" >> result_A15.txt

for SIZE_CL1 in 16 32 64 128 256
do
	FILEA7="simu/simu_dijkstra_A7_CL1_${SIZE_CL1}.out"
	FILEA15="simu/simu_dijkstra_A15_CL1_${SIZE_CL1}.out"
	LINEA7="${SIZE_CL1}"
	LINEA15="${SIZE_CL1}"
	for D in sim_cycle sim_IPC sim_CPI il1.miss_rate dl1.miss_rate ul2.miss_rate bpred_dir_rate ifq_rate ifq_full ruu_rate ruu_full lsq_rate lsq_full
	do
		LINEA7+=";`grep ${D} $FILEA7 | cut -d# -f1 | sed -e "s/[a-z0-9._]*${D}//g" -e "s/ //g"`"
		LINEA15+=";`grep ${D} $FILEA15 | cut -d# -f1 | sed -e "s/[a-z0-9._]*${D}//g" -e "s/ //g"`"
	done
	echo $LINEA7 >> result_A7.txt
	echo $LINEA15 >> result_A15.txt
done



