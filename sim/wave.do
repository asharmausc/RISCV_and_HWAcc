onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/reset_n
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/clk
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/pc_en
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/wea
add wave -noupdate -expand -group FIFO_IN -radix decimal -childformat {{{/ALU_datapath_TB/inst_fifo_sram/addra[9]} -radix decimal} {{/ALU_datapath_TB/inst_fifo_sram/addra[8]} -radix decimal} {{/ALU_datapath_TB/inst_fifo_sram/addra[7]} -radix decimal} {{/ALU_datapath_TB/inst_fifo_sram/addra[6]} -radix decimal} {{/ALU_datapath_TB/inst_fifo_sram/addra[5]} -radix decimal} {{/ALU_datapath_TB/inst_fifo_sram/addra[4]} -radix decimal} {{/ALU_datapath_TB/inst_fifo_sram/addra[3]} -radix decimal} {{/ALU_datapath_TB/inst_fifo_sram/addra[2]} -radix decimal} {{/ALU_datapath_TB/inst_fifo_sram/addra[1]} -radix decimal} {{/ALU_datapath_TB/inst_fifo_sram/addra[0]} -radix decimal}} -subitemconfig {{/ALU_datapath_TB/inst_fifo_sram/addra[9]} {-height 15 -radix decimal} {/ALU_datapath_TB/inst_fifo_sram/addra[8]} {-height 15 -radix decimal} {/ALU_datapath_TB/inst_fifo_sram/addra[7]} {-height 15 -radix decimal} {/ALU_datapath_TB/inst_fifo_sram/addra[6]} {-height 15 -radix decimal} {/ALU_datapath_TB/inst_fifo_sram/addra[5]} {-height 15 -radix decimal} {/ALU_datapath_TB/inst_fifo_sram/addra[4]} {-height 15 -radix decimal} {/ALU_datapath_TB/inst_fifo_sram/addra[3]} {-height 15 -radix decimal} {/ALU_datapath_TB/inst_fifo_sram/addra[2]} {-height 15 -radix decimal} {/ALU_datapath_TB/inst_fifo_sram/addra[1]} {-height 15 -radix decimal} {/ALU_datapath_TB/inst_fifo_sram/addra[0]} {-height 15 -radix decimal}} /ALU_datapath_TB/inst_fifo_sram/addra
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/dina
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/web
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/addrb
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/dinb
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/fifo_input
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/reb
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/sram_data_out
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/fifo_output
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/sram_data_out
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/fifo_output
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/almfull
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/fifo_empty
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/stall
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/full
add wave -noupdate -expand -group FIFO_IN /ALU_datapath_TB/inst_fifo_sram/empty
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/DWIDTH
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/AWIDTH
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/clk
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/reset_n
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/pc_en
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/i_ctrl
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/tail_addr
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/head_addr
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/wea
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/addra
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/dina
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/douta
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/fifo_sel
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/drop_packet
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/stop_tx
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/stall
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/prev_control
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/head_pointer
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/tail_pointer
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/register_0
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/register_1
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/register_2
add wave -noupdate -group controller /ALU_datapath_TB/inst_fifo_sram/inst_controller/register_3
add wave -noupdate /ALU_datapath_TB/inst_datapath/inst_decoder/clk
add wave -noupdate /ALU_datapath_TB/inst_datapath/inst_decoder/reset_n
add wave -noupdate -group decoder /ALU_datapath_TB/inst_datapath/inst_decoder/instr
add wave -noupdate -group decoder /ALU_datapath_TB/inst_datapath/inst_decoder/pc
add wave -noupdate -group decoder /ALU_datapath_TB/inst_datapath/inst_decoder/rd
add wave -noupdate -group decoder /ALU_datapath_TB/inst_datapath/inst_decoder/rs1
add wave -noupdate -group decoder /ALU_datapath_TB/inst_datapath/inst_decoder/rs2
add wave -noupdate -group decoder /ALU_datapath_TB/inst_datapath/inst_decoder/immed
add wave -noupdate -group decoder /ALU_datapath_TB/inst_datapath/inst_decoder/func
add wave -noupdate -group decoder /ALU_datapath_TB/inst_datapath/inst_decoder/joffset
add wave -noupdate -group decoder /ALU_datapath_TB/inst_datapath/inst_decoder/ctrl
add wave -noupdate /ALU_datapath_TB/inst_datapath/inst_reg_file/memory_reg
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[20]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[19]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[18]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[17]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[16]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[15]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[14]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[13]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[12]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[11]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[10]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[9]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[8]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[7]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[6]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[5]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[4]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[3]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[2]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[1]}
add wave -noupdate -group FIFO_MEM {/ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/memory_reg[0]}
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/dina
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/addra
add wave -noupdate /ALU_datapath_TB/inst_fifo_sram/inst_fifo_ram/douta
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2963564 ps} 0}
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
WaveRestoreZoom {0 ps} {787500 ps}
