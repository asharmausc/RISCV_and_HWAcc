onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ALU_datapath_TB/inst_datapath/clk
add wave -noupdate /ALU_datapath_TB/inst_datapath/reset_n
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc_en
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {953058 ps} 0}
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
WaveRestoreZoom {850635 ps} {1025325 ps}
