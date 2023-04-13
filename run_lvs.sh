#!/bin/bash
#
# run_lvs.sh --
#
# Run LVS on layout vs. schematic.  Assumes that the schematic netlist
# has been saved locally as "zero_opamp.spice" (may need to be copied
# from ~/.xschem/simulations/).  The layout netlist is generated
# automatically by this script.
#
# Set environment variable PDK_ROOT if your PDK is installed in a
# location other than the open_pdks default /usr/local/share/pdk/.
#
# Copyright 2023 R. Timothy Edwards

echo ${PDK_ROOT:=/usr/local/share/pdk} > /dev/null
echo ${PDK:=sky130A} > /dev/null

magic -dnull -noconsole -rcfile $PDK_ROOT/$PDK/libs.tech/magic/$PDK.magicrc << EOF
drc off
crashbackups stop
load zero_opamp
select top cell
expand
extract do local
extract all
ext2spice lvs
ext2spice -o zero_opamp_layout.spice
EOF
rm -f *.ext

# export NETGEN_COLUMNS=50
netgen -batch lvs "zero_opamp_layout.spice zero_opamp" "zero_opamp.spice zero_opamp" \
        $PDK_ROOT/$PDK/libs.tech/netgen/${PDK}_setup.tcl zero_opamp_comp.out
