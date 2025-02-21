vlib work
vlog -reportprogress 300 -work work -L mtiAvm -L mtiRnm -L mtiOvm -L mtiUvm -L mtiUPF -L infact ./TestBench.sv
vlog -reportprogress 300 -work work -L mtiAvm -L mtiRnm -L mtiOvm -L mtiUvm -L mtiUPF -L infact ./UART_Rec.sv  
vsim -voptargs=+acc work.TB

add wave -position insertpoint  sim:/uart_rec/clk
add wave -position insertpoint  sim:/uart_rec/rx
add wave -position insertpoint  sim:/uart_rec/e_state
add wave -position insertpoint  sim:/TB/uart_rec/data
add wave -position insertpoint  sim:/TB/uart_rec/i
add wave -position insertpoint  sim:/TB/rx
add wave -position insertpoint  sim:/TB/data_valid

