onerror {resume}
quietly set dataset_list [list sim vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate sim:/tb_regfile/err
add wave -noupdate sim:/tb_regfile/nerr
add wave -noupdate -radix unsigned sim:/tb_regfile/w_data
add wave -noupdate -radix unsigned sim:/tb_regfile/w_addr
add wave -noupdate -radix unsigned sim:/tb_regfile/r_addr
add wave -noupdate sim:/tb_regfile/clk
add wave -noupdate sim:/tb_regfile/w_en
add wave -noupdate -radix unsigned sim:/tb_regfile/r_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {184 ps}
