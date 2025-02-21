module shield_test (input clk, input s_out, output[3:1] oe, output [3:1] dir, output [2:1] dbg, output [4:1] D );

assign oe = 3'b000;
assign dir = 3'b010;

parameter SIMUL_FREQ_Hz = 10**9.0; 
parameter CPLD_CLK_Hz   = 66_000_000.0;	
parameter BOUD_RATE_bps = 9600.0; 	     

parameter CLK_PERIOD_ns = SIMUL_FREQ_Hz / CPLD_CLK_Hz; 		   
parameter CLKS_PER_BIT  = CPLD_CLK_Hz / BOUD_RATE_bps; 
parameter BIT_ns        = SIMUL_FREQ_Hz / BOUD_RATE_bps; 


reg s_out_z1 = 0;
reg [7:0] data = 0;
reg data_valid = 0;

reg s_out_sync; always @(posedge clk) s_out_sync = ~s_out;

assign D = ~data[3:0];
// assign D[1] = data_valid;

assign dbg[2] = data[0];
assign dbg[1] = s_out_sync;

UART_Rec uart_rec(.clk(clk), .rx(s_out_sync), .data(data), .data_valid(data_valid));

endmodule