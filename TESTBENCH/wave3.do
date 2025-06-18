onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/clk
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/rst
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_vld
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_key
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_sel
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/s_axis_tdata
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/s_axis_tvalid
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/s_axis_tlast
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/s_axis_tready
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/s_axis_tuser
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/m_axis_tdata
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/m_axis_tvalid
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/m_axis_tlast
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/m_axis_tuser
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/s_axis_tdata_128
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/s_axis_tvalid_128
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/s_axis_tlast_128
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/s_axis_tready_128
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/m_axis_tdata_128_d1
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/m_axis_tdata_128
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/m_axis_tvalid_128
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/m_axis_tlast_128
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/count
add wave -noupdate -expand -group sm4-8 /sm4_top_axis8_tb/sm4_top_axis8_inst/m_axis_tlast_d
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/clk
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/rst
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/sm4_vld
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/sm4_key
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/sm4_sel
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/s_axis_tdata
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/s_axis_tvalid
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/s_axis_tlast
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/s_axis_tready
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/m_axis_tdata
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/m_axis_tvalid
add wave -noupdate -group sm4-128 /sm4_top_axis8_tb/sm4_top_axis8_inst/sm4_top_axis128_inst/m_axis_tlast
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2255000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {1476800 ps} {2856700 ps}
