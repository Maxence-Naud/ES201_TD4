rm result_*


for TYPE in nottaken taken perfect bimod 2lev
do
	FILE="simu/simu_${TYPE}.out" 
	echo $FILE >> result_bpred.txt
	grep sim_cycle $FILE >> result_bpred.txt
	grep sim_CPI $FILE >> result_bpred.txt
done 

for SIZE in 16 32 64 128
do
	FILE="simu/simu_ruu${SIZE}.out" 
	echo $FILE >> result_ruu.txt
	grep sim_cycle $FILE >> result_ruu.txt
	grep sim_CPI $FILE >> result_ruu.txt
done 

for APP in normale pointer tempo unrol
do
	FILE1="simu/simu_cache_C1_${APP}.out"
	FILE2="simu/simu_cache_C2_${APP}.out"
	echo $FILE1 >> result_cache.txt
	grep il1.miss_rate $FILE1 >> result_cache.txt
	grep dl1.miss_rate $FILE1 >> result_cache.txt
	grep ul2.miss_rate $FILE1 >> result_cache.txt
	echo $FILE2 >> result_cache.txt
	grep il1.miss_rate $FILE2 >> result_cache.txt
	grep dl1.miss_rate $FILE2 >> result_cache.txt
	grep ul2.miss_rate $FILE2 >> result_cache.txt

done


