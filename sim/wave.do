onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/i_clock
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/i_reset_n
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/in_data
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/in_ctrl
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/in_wr
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/in_rdy
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/out_rdy
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/data_count
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/out_data
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/out_ctrl
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/out_wr
add wave -noupdate -expand -group H_Parser /HWAcc_n_header_parser_TB/inst_headerparser/o_inside_payload
add wave -noupdate /HWAcc_n_header_parser_TB/inst_fifo_sram/wea
add wave -noupdate /HWAcc_n_header_parser_TB/inst_fifo_sram/fifo_input
add wave -noupdate /HWAcc_n_header_parser_TB/inst_fifo_sram/reb
add wave -noupdate /HWAcc_n_header_parser_TB/inst_fifo_sram/fifo_output
add wave -noupdate -expand -group HParser2 /HWAcc_n_header_parser_TB/inst_headerparser_2/in_data
add wave -noupdate -expand -group HParser2 /HWAcc_n_header_parser_TB/inst_headerparser_2/in_ctrl
add wave -noupdate -expand -group HParser2 /HWAcc_n_header_parser_TB/inst_headerparser_2/in_wr
add wave -noupdate -expand -group HParser2 /HWAcc_n_header_parser_TB/inst_headerparser_2/in_rdy
add wave -noupdate -expand -group HParser2 /HWAcc_n_header_parser_TB/inst_headerparser_2/out_data
add wave -noupdate -expand -group HParser2 /HWAcc_n_header_parser_TB/inst_headerparser_2/out_ctrl
add wave -noupdate -expand -group HParser2 /HWAcc_n_header_parser_TB/inst_headerparser_2/out_wr
add wave -noupdate -expand -group HParser2 /HWAcc_n_header_parser_TB/inst_headerparser_2/out_rdy
add wave -noupdate -expand -group HParser2 /HWAcc_n_header_parser_TB/inst_headerparser_2/data_count
add wave -noupdate -expand -group HParser2 /HWAcc_n_header_parser_TB/inst_headerparser_2/o_inside_payload
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/in_data
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/in_ctrl
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/in_wr
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/in_rdy
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/out_data
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/out_ctrl
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/out_wr
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/out_rdy
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/key
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/data_count
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/inside_payload
add wave -noupdate -group HW_ACC2 /HWAcc_n_header_parser_TB/inst_HWACC_decrypt/path_sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3298528 ps} 0}
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
WaveRestoreZoom {3193098 ps} {3317130 ps}
