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
vsim -L common_ver -L ph1_ver -novopt tb_sm4_top
#
# Add waves
#
add wave tb_sm4_top/*
#do wave-clientfifo.do
# do wave.do
#
# Run simulation
#
run -all
#
# End