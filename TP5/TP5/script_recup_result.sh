
GEM5=/home/c/cathebras/ES201/tools/TP5/gem5-stable

GEM5_FAST=$GEM5/build/ARM/gem5.fast
GEM5_OPT=$GEM5/build/ARM/gem5.opt

# SYSTEM CONFIGURATION
CONFIG_SE=$GEM5/configs/example/se.py
# SYSTEM OPTIONS
OPTION_SE=$GEM5/configs/common/Options.py
# SUPERSCALAR PROCESSOR ELEMENT
O3CPU=$GEM5/src/cpu/o3/O3CPU.py


TOTAL_INST=""
CPU_CYCLE="system.cpu??.numCycles"


STAT_GEM5=./m5out/stats.txt

APP="test_omp"

CPU_SCAL="--cpu-type=atomic"
CPU_A7="--cpu-type=arm_detailed"
CPU_A15="--cpu-type=detailed"

TM=40

mkdir -p simu/log
mkdir -p simu/stat

for N_THREAD in 1 2 4 8 16 32 
do
	FILE_LOG="${PWD}/simu/log/gem5_log_A7_M${TM}_C${N_THREAD}"
	FILE_STAT="${PWD}/simu/stat/gem5_stat_A7_M${TM}_C${N_THREAD}"
	REDIR_OUTPUT="--output=${FILE_LOG}"
	CACHE="--caches"
	NB_CORE="-n ${N_THREAD}"
	if [ ! -s $FILE_STAT ]; then
		$GEM5_FAST $CONFIG_SE $CPU_A7 $CACHE $REDIR_OUTPUT $NB_CORE -c ${APP} -o "${N_THREAD} ${TM}"
		cp $STAT_GEM5 $FILE_STAT
	fi
done

for N_WAY in 2 4 8
do
	for N_THREAD in 1 2 4 8 16 32 
	do
		FILE_LOG="${PWD}/simu/log/gem5_log_A15_M${TM}_W${N_WAY}_C${N_THREAD}"
		FILE_STAT="${PWD}/simu/stat/gem5_stat_A15_M${TM}_W${N_WAY}_C${N_THREAD}"
		REDIR_OUTPUT="--output=${FILE_LOG}"
		CACHE="--caches -w ${N_WAY}"
		NB_CORE="-n ${N_THREAD}"
		if [ ! -s $FILE_STAT ]; then
			$GEM5_FAST $CONFIG_SE $CPU_A15 $CACHE $REDIR_OUTPUT $NB_CORE -c ${APP} -o "${N_THREAD} ${TM}"
			cp $STAT_GEM5 $FILE_STAT
		fi
	done
done





