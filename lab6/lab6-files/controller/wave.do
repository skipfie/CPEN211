onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Output
add wave -noupdate /tb_controller/wb_sel
add wave -noupdate -radix binary /tb_controller/w_en
add wave -noupdate -radix binary /tb_controller/sel_A
add wave -noupdate -radix binary /tb_controller/sel_B
add wave -noupdate -radix binary /tb_controller/waiting
add wave -noupdate /tb_controller/reg_sel
add wave -noupdate /tb_controller/nerr
add wave -noupdate /tb_controller/opcode
add wave -noupdate /tb_controller/err
add wave -noupdate /tb_controller/en_status
add wave -noupdate -radix binary /tb_controller/en_C
add wave -noupdate /tb_controller/en_B
add wave -noupdate /tb_controller/en_A
add wave -noupdate -divider Input
add wave -noupdate /tb_controller/clk
add wave -noupdate /tb_controller/rst_n
add wave -noupdate /tb_controller/ALU_op
add wave -noupdate /tb_controller/failed
add wave -noupdate /tb_controller/start
add wave -noupdate -radix decimal /tb_controller/dut/state
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
WaveRestoreZoom {0 ps} {354 ps}
