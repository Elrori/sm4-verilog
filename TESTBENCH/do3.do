#
# Create work library
#
vlib work
#
# Compile sources
#

vlog  -sv "*.v"

vlog "../RTL/*.v"

#
# Call vsim to invoke simulator
#
vsim -L common_ver -L ph1_ver -novopt sm4_top_axis8_tb
#
# Add waves
#
# add wave sm4_top_axis8_tb/*
#do wave-clientfifo.do
do wave3.do
#
# Run simulation
#
run -all
#
# End