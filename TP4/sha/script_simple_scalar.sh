#/bin/bash

SIM_PROFILE=/usr/ensta/pack/simplescalar-3v0d/simplesim-3.0/sim-profile

PRG_SS="sha input_small.asc"

REDIR_OUT_SIMU="-redir:sim simu.out"

OPTIONS="-iclass -iprof"


$SIM_PROFILE $OPTIONS $REDIR_OUT_SIMU $PRG_SS


