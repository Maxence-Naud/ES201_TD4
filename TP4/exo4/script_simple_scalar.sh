#!/bin/bash

SIM_PROFILE=/usr/ensta/pack/simplescalar-3v0d/simplesim-3.0/sim-profile
SIM_OUT_ORDER=/usr/ensta/pack/simplescalar-3v0d/simplesim-3.0/sim-outorder
SIM_CACHE=/usr/ensta/pack/simplescalar-3v0d/simplesim-3.0/sim-cache

mkdir -p simu

PRG_SS1="blowfish/bf.ss e blowfish/input_small.asc blowfish/output_small.enc 1234567890abcdeffedcba0987654321"
PRG_SS2="dijkstra/dijkstra_small.ss dijkstra/input.dat > dijkstra/output_small.dat"

REDIR_OUT_SIMU1="-redir:sim simu/simu_blowfish.out"
REDIR_OUT_SIMU2="-redir:sim simu/simu_dijkstra.out"

OPTIONS="-iclass -iprof"

$SIM_PROFILE $OPTIONS $REDIR_OUT_SIMU1 $PRG_SS1
$SIM_PROFILE $OPTIONS $REDIR_OUT_SIMU2 $PRG_SS2

A15_IL1="-cache:il1 il1:256:64:2:l"
A15_DL1="-cache:dl1 dl1:256:64:2:l"
A15_IL2="-cache:il2 dl2"
A15_DL2="-cache:dl2 ul2:512:64:16:l"
A15_BPRED="-bpred 2lev -bpred:btb 256 8"
A15_FETCH="-fetch:ifqsize 8"
A15_DEC_ISS_COM="-decode:width 4 -issue:width 8 -commit:width 4"
A15_RUU_LSQ="-ruu:size 16 -lsq:size 16"
A15_ALU_INT_FP="-res:ialu 5 -res:fpalu 1"
A15_MUL_INT_FP="-res:imult 1 -res:fpmult 1"

A7_IL1="-cache:il1 il1:512:32:2:l"
A7_DL1="-cache:dl1 dl1:512:32:2:l"
A7_IL2="-cache:il2 dl2"
A7_DL2="-cache:dl2 ul2:2048:32:8:l"
A7_BPRED="-bpred bimod -bpred:btb 256 8"
A7_FETCH="-fetch:ifqsize 4"
A7_DEC_ISS_COM="-decode:width 2 -issue:width 4 -commit:width 2"
A7_RUU_LSQ="-ruu:size 2 -lsq:size 8"
A7_ALU_INT_FP="-res:ialu 1 -res:fpalu 1"
A7_MUL_INT_FP="-res:imult 1 -res:fpmult 1"


for SIZE_CL1 in 16 32 64 128 256
do
	A7_IL1="-cache:il1 il1:${SIZE_CL1}:32:2:l"
	A7_DL1="-cache:dl1 dl1:${SIZE_CL1}:32:2:l"
	A15_IL1="-cache:il1 il1:${SIZE_CL1}:64:2:l"
	A15_DL1="-cache:dl1 dl1:${SIZE_CL1}:64:2:l"

	OPTION_A7="$A7_MUL_INT_FP $A7_ALU_INT_FP $A7_RUU_LSQ $A7_DEC_ISS_COM $A7_FETCH $A7_BPRED $A7_IL1 $A7_DL1 $A7_IL2 $A7_DL2"
	OPTION_A15="$A15_MUL_INT_FP $A15_ALU_INT_FP $A15_RUU_LSQ $A15_DEC_ISS_COM $A15_FETCH $A15_BPRED $A15_IL1 $A15_DL1 $A15_IL2 $A15_DL2"

	REDIR_OUT_SIMU1_1="-redir:sim simu/simu_blowfish_A7_CL1_${SIZE_CL1}.out"
	REDIR_OUT_SIMU1_2="-redir:sim simu/simu_dijkstra_A7_CL1_${SIZE_CL1}.out"
	REDIR_OUT_SIMU2_1="-redir:sim simu/simu_blowfish_A15_CL1_${SIZE_CL1}.out"
	REDIR_OUT_SIMU2_2="-redir:sim simu/simu_dijkstra_A15_CL1_${SIZE_CL1}.out"
	echo $OPTION_A7 $PRG_SS1
	$SIM_OUT_ORDER $OPTION_A7 $REDIR_OUT_SIMU1_1 $PRG_SS1
	echo $OPTION_A7 $PRG_SS2
	$SIM_OUT_ORDER $OPTION_A7 $REDIR_OUT_SIMU1_2 $PRG_SS2
	echo $OPTION_A15 $PRG_SS1
	$SIM_OUT_ORDER $OPTION_A15 $REDIR_OUT_SIMU2_1 $PRG_SS1
	echo $OPTION_A15 $PRG_SS2
	$SIM_OUT_ORDER $OPTION_A15 $REDIR_OUT_SIMU2_2 $PRG_SS2

done


