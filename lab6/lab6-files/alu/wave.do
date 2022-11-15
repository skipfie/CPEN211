onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ALU/ALU_op
add wave -noupdate /tb_ALU/ALU_out
add wave -noupdate -radix binary /tb_ALU/N
add wave -noupdate -radix binary /tb_ALU/V
add wave -noupdate -radix binary /tb_ALU/Z
add wave -noupdate /tb_ALU/err
add wave -noupdate -radix decimal /tb_ALU/failed_count
add wave -noupdate /tb_ALU/nerr
add wave -noupdate /tb_ALU/val_A
add wave -noupdate -radix decimal /tb_ALU/val_B
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
WaveRestoreZoom {0 ps} {1 ns}