onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /tb_task3/dut/out
add wave -noupdate -radix hexadecimal /tb_task3/dut/cpu/program_counter
add wave -noupdate /tb_task3/dut/cpu/controller/state
add wave -noupdate -radix decimal {/tb_task3/dut/ram/m[255]}
add wave -noupdate -radix decimal {/tb_task3/dut/ram/m[254]}
add wave -noupdate -radix decimal -childformat {{{/tb_task3/dut/cpu/datapath/regfile/m[0]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[1]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[2]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[3]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[4]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[5]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[6]} -radix decimal} {{/tb_task3/dut/cpu/datapath/regfile/m[7]} -radix binary}} -expand -subitemconfig {{/tb_task3/dut/cpu/datapath/regfile/m[0]} {-height 15 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[1]} {-height 15 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[2]} {-height 15 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[3]} {-height 15 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[4]} {-height 15 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[5]} {-height 15 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[6]} {-height 15 -radix decimal} {/tb_task3/dut/cpu/datapath/regfile/m[7]} {-height 15 -radix binary}} /tb_task3/dut/cpu/datapath/regfile/m
add wave -noupdate /tb_task3/dut/cpu/idecoder/opcode
add wave -noupdate /tb_task3/dut/cpu/idecoder/ALU_op
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {310 ps} 0}
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
WaveRestoreZoom {476 ps} {584 ps}
