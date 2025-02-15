module UART_Rec(
    input clk,
    input rx,
    output reg [10:0] data,
    output reg data_valid
);

   // independent parameters
   parameter SIMUL_FREQ_Hz = 1_000_000_000.0;                                         
   parameter CLK_Hz        = 66_000_000.0; 
   parameter BITRATE_bps   = 9_600.0;     

   // derived parameters
   parameter CLK_PERIOD_ps = (SIMUL_FREQ_Hz / CLK_Hz);
   parameter BIT_ps  = (SIMUL_FREQ_Hz / BITRATE_bps);
   parameter BIT_clk = CLK_Hz / BITRATE_bps;

   enum {IDLE, BUSY} e_state = IDLE;
   reg [3:0]  frame_ctr = 0;
   reg [20:0] clock_ticks = 0;

   always @(posedge clk) begin
	case(e_state)

	IDLE: begin
	if(rx == 0) begin
		frame_ctr = frame_ctr + 1;
		e_state = BUSY;
		// $display("Frame number: ", frame_ctr);
		end
	end

	BUSY: begin
		clock_ticks = clock_ticks + 1;
        // data[clock_ticks] = rx;
        // $display("Current bit: ", rx);
		if(clock_ticks == BIT_clk) begin
            e_state = IDLE;
            clock_ticks = 0;
        end
	end
	endcase
   end

endmodule