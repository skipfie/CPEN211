onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_task1/dut/clk
add wave -noupdate /tb_task1/dut/cpu/rst_n
add wave -noupdate /tb_task1/dut/cpu/start_pc
add wave -noupdate /tb_task1/dut/cpu/ram_r_data
add wave -noupdate /tb_task1/dut/cpu/ram_w_en
add wave -noupdate /tb_task1/dut/cpu/ram_w_data
add wave -noupdate /tb_task1/dut/cpu/out
add wave -noupdate /tb_task1/dut/cpu/controller/state
add wave -noupdate -divider registers
add wave -noupdate /tb_task1/dut/cpu/load_ir
add wave -noupdate /tb_task1/dut/cpu/instr_reg
add wave -noupdate /tb_task1/dut/cpu/load_pc
add wave -noupdate -radix decimal /tb_task1/dut/cpu/program_counter
add wave -noupdate /tb_task1/dut/cpu/load_addr
add wave -noupdate /tb_task1/dut/cpu/data_addr_reg
add wave -noupdate -divider mux
add wave -noupdate /tb_task1/dut/cpu/clear_pc
add wave -noupdate /tb_task1/dut/cpu/next_pc
add wave -noupdate /tb_task1/dut/cpu/sel_addr
add wave -noupdate -radix hexadecimal /tb_task1/dut/cpu/ram_addr
add wave -noupdate -divider {datapath signals}
add wave -noupdate /tb_task1/dut/cpu/ALU_op
add wave -noupdate /tb_task1/dut/cpu/shift_op
add wave -noupdate /tb_task1/dut/cpu/opcode
add wave -noupdate /tb_task1/dut/cpu/r_addr
add wave -noupdate /tb_task1/dut/cpu/w_addr
add wave -noupdate /tb_task1/dut/cpu/sximm5
add wave -noupdate /tb_task1/dut/cpu/sximm8
add wave -noupdate /tb_task1/dut/cpu/w_en
add wave -noupdate /tb_task1/dut/cpu/en_A
add wave -noupdate /tb_task1/dut/cpu/en_B
add wave -noupdate /tb_task1/dut/cpu/sel_A
add wave -noupdate /tb_task1/dut/cpu/sel_B
add wave -noupdate /tb_task1/dut/cpu/en_C
add wave -noupdate /tb_task1/dut/cpu/en_status
add wave -noupdate /tb_task1/dut/cpu/reg_sel
add wave -noupdate /tb_task1/dut/cpu/wb_sel
add wave -noupdate /tb_task1/dut/cpu/N
add wave -noupdate /tb_task1/dut/cpu/V
add wave -noupdate /tb_task1/dut/cpu/Z
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {53 ps} 0}
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
WaveRestoreZoom {0 ps} {124 ps}
