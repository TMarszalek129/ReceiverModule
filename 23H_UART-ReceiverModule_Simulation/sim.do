vlib work
vlog -reportprogress 300 -work work -L mtiAvm -L mtiRnm -L mtiOvm -L mtiUvm -L mtiUPF -L infact ./TestBench.sv
vlog -reportprogress 300 -work work -L mtiAvm -L mtiRnm -L mtiOvm -L mtiUvm -L mtiUPF -L infact ./UART_Rec.sv  
vsim -voptargs=+acc work.TB

add wave -position insertpoint  sim:/uart_rec/clk
add wave -position insertpoint  sim:/uart_rec/rx
