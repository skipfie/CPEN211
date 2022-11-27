onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_task3/dut/clk
add wave -noupdate /tb_task3/dut/cpu/rst_n
add wave -noupdate /tb_task3/dut/cpu/start_pc
add wave -noupdate /tb_task3/dut/cpu/ram_r_data
add wave -noupdate /tb_task3/dut/cpu/ram_w_en
add wave -noupdate /tb_task3/dut/cpu/ram_w_data
add wave -noupdate -radix decimal /tb_task3/dut/cpu/out
add wave -noupdate /tb_task3/dut/cpu/controller/state
add wave -noupdate -divider registers
add wave -noupdate /tb_task3/dut/cpu/load_ir
add wave -noupdate /tb_task3/dut/cpu/instr_reg
add wave -noupdate /tb_task3/dut/cpu/load_pc
add wave -noupdate -radix hexadecimal /tb_task3/dut/cpu/program_counter
add wave -noupdate /tb_task3/dut/cpu/load_addr
add wave -noupdate /tb_task3/dut/cpu/data_addr_reg
add wave -noupdate -divider mux
add wave -noupdate /tb_task3/dut/cpu/sel_addr
add wave -noupdate -radix hexadecimal /tb_task3/dut/cpu/ram_addr
add wave -noupdate /tb_task3/dut/cpu/clear_pc
add wave -noupdate -radix hexadecimal /tb_task3/dut/cpu/next_pc
add wave -noupdate -divider {datapath signals}
add wave -noupdate -label regfile -radix decimal -childformat {{{/tb_task3/dut/cpu/datapath/regfile/m[0]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[1]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[2]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[3]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[4]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[5]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[6]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[7]} -radix decimal}} -expand -subitemconfig {{/tb_task3/dut/cpu/datapath/regfile/m[0]} {-height 21 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[1]} {-height 21 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[2]} {-height 21 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[3]} {-height 21 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[4]} {-height 21 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[5]} {-height 21 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[6]} {-height 21 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[7]} {-height 21 -radix decimal}} /tb_task3/dut/cpu/datapath/regfile/m
add wave -noupdate /tb_task3/dut/cpu/opcode
add wave -noupdate /tb_task3/dut/cpu/ALU_op
add wave -noupdate /tb_task3/dut/cpu/shift_op
add wave -noupdate -radix unsigned /tb_task3/dut/cpu/r_addr
add wave -noupdate -radix unsigned /tb_task3/dut/cpu/w_addr
add wave -noupdate -radix decimal /tb_task3/dut/cpu/sximm5
add wave -noupdate -radix decimal /tb_task3/dut/cpu/sximm8
add wave -noupdate -radix binary /tb_task3/dut/cpu/w_en
add wave -noupdate -radix binary /tb_task3/dut/cpu/en_A
add wave -noupdate -radix binary /tb_task3/dut/cpu/en_B
add wave -noupdate -radix binary /tb_task3/dut/cpu/sel_A
add wave -noupdate -radix binary /tb_task3/dut/cpu/sel_B
add wave -noupdate -radix binary /tb_task3/dut/cpu/en_C
add wave -noupdate -radix binary /tb_task3/dut/cpu/en_status
add wave -noupdate /tb_task3/dut/cpu/reg_sel
add wave -noupdate /tb_task3/dut/cpu/wb_sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2039 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 172
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
WaveRestoreZoom {1898 ps} {2048 ps}
