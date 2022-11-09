onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_datapath/err
add wave -noupdate /tb_datapath/clk
add wave -noupdate /tb_datapath/wb_sel
add wave -noupdate /tb_datapath/en_A
add wave -noupdate /tb_datapath/en_B
add wave -noupdate /tb_datapath/sel_A
add wave -noupdate /tb_datapath/sel_B
add wave -noupdate /tb_datapath/en_C
add wave -noupdate /tb_datapath/en_status
add wave -noupdate /tb_datapath/shift_op
add wave -noupdate /tb_datapath/dut/val_A
add wave -noupdate /tb_datapath/dut/val_B
add wave -noupdate /tb_datapath/ALU_op
add wave -noupdate -divider regfile
add wave -noupdate /tb_datapath/w_en
add wave -noupdate -radix decimal -childformat {{{/tb_datapath/w_addr[2]} -radix decimal} {{/tb_datapath/w_addr[1]} -radix decimal} {{/tb_datapath/w_addr[0]} -radix decimal}} -subitemconfig {{/tb_datapath/w_addr[2]} {-height 15 -radix decimal} {/tb_datapath/w_addr[1]} {-height 15 -radix decimal} {/tb_datapath/w_addr[0]} {-height 15 -radix decimal}} /tb_datapath/w_addr
add wave -noupdate -radix decimal /tb_datapath/r_addr
add wave -noupdate /tb_datapath/dut/regfile/m
add wave -noupdate -radix decimal /tb_datapath/datapath_in
add wave -noupdate -radix decimal /tb_datapath/datapath_out
add wave -noupdate /tb_datapath/Z_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ps} 0}
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
WaveRestoreZoom {37 ps} {177 ps}
