module UART_Rec(
    input clk,
    input rx,
    output reg [7:0] data,
    output reg data_valid
);

   // independent parameters
   parameter SIMUL_FREQ_Hz = 1_000_000_000.0;                                         
   parameter CLK_Hz        = 66_000_000.0; 
   parameter BITRATE_bps   = 9_600.0;     

   // derived parameters
   parameter CLK_PERIOD_ps = (SIMUL_FREQ_Hz / CLK_Hz);
   parameter BIT_ns  = (SIMUL_FREQ_Hz / BITRATE_bps);
   parameter BIT_clk = CLK_Hz / BITRATE_bps;

   enum {IDLE, BUSY} e_state = IDLE;
   reg [3:0]  frame_ctr = 0;
   reg [20:0] clock_ticks = 0;
   int i = 0;
   reg rx_z1 = 0;

   always @(posedge clk) begin
	case(e_state)

	IDLE: begin
    data_valid = 0;
    i = 0;
	if(rx != rx_z1) begin
		frame_ctr = frame_ctr + 1;
		e_state = BUSY;
		end
	end

	BUSY: begin
		clock_ticks = clock_ticks + 1;
        if(clock_ticks % int'(BIT_clk) == 0) begin
            data[i] = rx;
            i = i + 1;
        end
		if(clock_ticks == int'(15 * BIT_clk)) begin
            e_state = IDLE;
            clock_ticks = 0;
            data_valid = 1;
        end
	end
	endcase
    rx_z1 = rx;
   end

endmodule