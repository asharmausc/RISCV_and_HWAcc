onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/i_clock
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/i_reset_n
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/in_data
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/in_ctrl
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/in_wr
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/in_rdy
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/out_data
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/out_ctrl
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/out_wr
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/out_rdy
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/key
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/data_count
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/inside_payload
add wave -noupdate /HWAcc_two_core_TB/inst_HWACC_encrypt/path_sel
add wave -noupdate {/HWAcc_two_core_TB/genblk1[0]/inst_fifo_sram/wea}
add wave -noupdate {/HWAcc_two_core_TB/genblk1[0]/inst_fifo_sram/fifo_input}
add wave -noupdate {/HWAcc_two_core_TB/genblk1[0]/inst_fifo_sram/reb}
add wave -noupdate {/HWAcc_two_core_TB/genblk1[0]/inst_fifo_sram/fifo_output}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3160000 ps} 0}
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
WaveRestoreZoom {1457357 ps} {4862643 ps}
