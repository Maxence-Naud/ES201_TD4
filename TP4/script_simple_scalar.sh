#!/bin/bash

SIM_PROFILE=/usr/ensta/pack/simplescalar-3v0d/simplesim-3.0/sim-profile
SIM_OUT_ORDER=/usr/ensta/pack/simplescalar-3v0d/simplesim-3.0/sim-outorder
SIM_CACHE=/usr/ensta/pack/simplescalar-3v0d/simplesim-3.0/sim-cache

#PRG_SS="sha.ss input_small.asc"
PRG_SS="dijkstra_small.ss"

REDIR_OUT_SIMU="-redir:sim simu.out"

mkdir -p simu

for TYPE in nottaken taken perfect bimod 2lev
do	
	OPTIONS="-bpred $TYPE"
	REDIR_OUT_SIMU="-redir:sim simu/simu_${TYPE}.out"
	$SIM_OUT_ORDER $OPTIONS $REDIR_OUT_SIMU $PRG_SS
done

for SIZE in 16 32 64 128
do	
	OPTIONS="-ruu:size $SIZE"
	REDIR_OUT_SIMU="-redir:sim simu/simu_ruu${SIZE}.out"
	$SIM_OUT_ORDER $OPTIONS $REDIR_OUT_SIMU $PRG_SS
done

C1_IL1="-cache:il1 il1:128:32:1:l"
C1_DL1="-cache:dl1 dl1:128:32:1:l"
C1_IL2="-cache:il2 dl2"
C1_DL2="-cache:dl2 ul2:1024:32:1:l"

C2_IL1="-cache:il1 il1:128:32:1:l"
C2_DL1="-cache:dl1 dl1:64:32:2:l"
C2_IL2="-cache:il2 dl2"
C2_DL2="-cache:dl2 ul2:256:32:4:l"

for APP in normale pointer tempo unrol
do
	
	REDIR_OUT_SIMU1="-redir:sim simu/simu_cache_C1_${APP}.out"
	REDIR_OUT_SIMU2="-redir:sim simu/simu_cache_C2_${APP}.out"
	$SIM_CACHE $C1_IL1 $C1_DL1 $C1_IL2 $C1_DL2 $REDIR_OUT_SIMU1 ${APP}.ss
	$SIM_CACHE $C2_IL1 $C2_DL1 $C2_IL2 $C2_DL2 $REDIR_OUT_SIMU2 ${APP}.ss

done



