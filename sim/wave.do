onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ALU_datapath_TB/inst_datapath/clk
add wave -noupdate /ALU_datapath_TB/inst_datapath/reset_n
add wave -noupdate /ALU_datapath_TB/inst_datapath/thread_IF
add wave -noupdate /ALU_datapath_TB/inst_datapath/thread_ID
add wave -noupdate /ALU_datapath_TB/inst_datapath/thread_EX
add wave -noupdate /ALU_datapath_TB/inst_datapath/thread_MEM
add wave -noupdate /ALU_datapath_TB/inst_datapath/thread_WB
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[30]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[29]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[28]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[27]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[26]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[25]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[24]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[23]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[22]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[21]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[20]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[19]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[18]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[17]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[16]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[15]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[14]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[13]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[12]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[11]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[10]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[9]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[8]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[7]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[6]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[5]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[4]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[3]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[2]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[1]}
add wave -noupdate {/ALU_datapath_TB/inst_datapath/inst_dmem/memory_reg[0]}
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc0
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc1
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc2
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc3
add wave -noupdate /ALU_datapath_TB/inst_datapath/pc
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/wea
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/fifo_input
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/reb
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/fifo_output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1307645 ps} 0}
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
WaveRestoreZoom {0 ps} {11686500 ps}
