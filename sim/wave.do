onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/reset_n
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/clk
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/wea
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/fifo_input
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/reb
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/fifo_output
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/wea
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/reb
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/fifo_output
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/fifo_input
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/inst_controller/fifo_sel
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/inst_controller/stop_tx
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/inst_controller/stall
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/inst_controller/prev_control
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/inst_controller/head_pointer
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/inst_controller/register_0
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/inst_controller/register_1
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/inst_controller/register_2
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/inst_controller/register_3
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/inst_controller/state
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/wea
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram1/fifo_input
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15670000 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {84 us}
