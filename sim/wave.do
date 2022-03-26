onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ALU_datapath_TB/inst_datapath/clk
add wave -noupdate /ALU_datapath_TB/inst_datapath/reset_n
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc_en
add wave -noupdate /ALU_datapath_TB/inst_datapath/inst_decoder/instr
add wave -noupdate /ALU_datapath_TB/inst_datapath/inst_decoder/ctrl
add wave -noupdate /ALU_datapath_TB/inst_datapath/instr_ID
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc0
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc1
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc2
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc3
add wave -noupdate /ALU_datapath_TB/inst_datapath/thread_IF
add wave -noupdate /ALU_datapath_TB/inst_datapath/thread_ID
add wave -noupdate /ALU_datapath_TB/inst_datapath/thread_EX
add wave -noupdate /ALU_datapath_TB/inst_datapath/thread_WB
add wave -noupdate /ALU_datapath_TB/inst_datapath/thread_MEM
add wave -noupdate /ALU_datapath_TB/inst_datapath/branch_taken
add wave -noupdate /ALU_datapath_TB/inst_datapath/jump_pc
add wave -noupdate /ALU_datapath_TB/inst_datapath/instr_ID
add wave -noupdate /ALU_datapath_TB/inst_datapath/branch_taken_MEM
add wave -noupdate /ALU_datapath_TB/inst_datapath/ctrl_MEM
add wave -noupdate /ALU_datapath_TB/inst_datapath/ctrl_ID
add wave -noupdate /ALU_datapath_TB/inst_datapath/ctrl_EX
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/inst_controller/fifo_sel
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/inst_controller/stop_tx
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/inst_controller/stall
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/web
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/wea
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/fifo_input
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/reb
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/fifo_output
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/inst_controller/drop_packet
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/inst_controller/register_0
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/inst_controller/register_1
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/inst_controller/register_2
add wave -noupdate -label sim:/ALU_datapath_TB/inst_fifo_sram/Group1 -group {Region: sim:/ALU_datapath_TB/inst_fifo_sram} /ALU_datapath_TB/inst_fifo_sram/inst_controller/register_3
add wave -noupdate -label /Group1 -group {Region: } {/ALU_datapath_TB/inst_datapath/inst_regfilex4/inst_reg_file_1/memory_reg[5]}
add wave -noupdate -label /Group1 -group {Region: } {/ALU_datapath_TB/inst_datapath/inst_regfilex4/inst_reg_file_1/memory_reg[4]}
add wave -noupdate -label /Group1 -group {Region: } {/ALU_datapath_TB/inst_datapath/inst_regfilex4/inst_reg_file_2/memory_reg[5]}
add wave -noupdate -label /Group1 -group {Region: } {/ALU_datapath_TB/inst_datapath/inst_regfilex4/inst_reg_file_2/memory_reg[4]}
add wave -noupdate -label /Group1 -group {Region: } {/ALU_datapath_TB/inst_datapath/inst_regfilex4/inst_reg_file_3/memory_reg[5]}
add wave -noupdate -label /Group1 -group {Region: } {/ALU_datapath_TB/inst_datapath/inst_regfilex4/inst_reg_file_3/memory_reg[4]}
add wave -noupdate -label /Group1 -group {Region: } {/ALU_datapath_TB/inst_datapath/inst_regfilex4/inst_reg_file_4/memory_reg[5]}
add wave -noupdate -label /Group1 -group {Region: } {/ALU_datapath_TB/inst_datapath/inst_regfilex4/inst_reg_file_4/memory_reg[4]}
add wave -noupdate /ALU_datapath_TB/inst_datapath/func_EX
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4300000 ps} 1} {{Cursor 2} {4265444 ps} 1} {{Cursor 3} {3874832 ps} 1} {{Cursor 4} {1230000 ps} 0}
quietly wave cursor active 4
configure wave -namecolwidth 227
configure wave -valuecolwidth 151
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
WaveRestoreZoom {0 ps} {2100 ns}
