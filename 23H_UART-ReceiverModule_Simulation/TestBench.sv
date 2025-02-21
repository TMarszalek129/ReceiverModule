`timescale 1ns/1ns
module TB();
 
   // independent parameters
   parameter SIMUL_FREQ_Hz = 1_000_000_000.0; 
   parameter CLK_Hz        = 66_000_000.0; 
   parameter BITRATE_bps   = 9_600.0;     

   // derived parameters
   parameter CLK_PERIOD_ps = (SIMUL_FREQ_Hz / CLK_Hz)  ;
   parameter BIT_ns  = (SIMUL_FREQ_Hz / BITRATE_bps)  ;
   parameter BIT_clk = CLK_Hz / BITRATE_bps;

   // variables
   reg clk; 
//    int DATA [3] = {8'h1A, 8'h2B, 8'h30};
//    int DATA [3] = {8'hA1, 8'hA3, 8'hA5};
   int DATA [3] = {8'h5, 8'h8, 8'h11};
   reg rx;
   reg[8:0] data;
   reg data_valid;

   // clock signal generation
   initial 
      forever begin
         clk = 0; #(CLK_PERIOD_ps/2);
         clk = 1; #(CLK_PERIOD_ps/2);
		 if(data_valid == 1)
					$display("DATA received: %02x", int'(data));  
      end
	  
   // data sending
   initial begin
		#(BIT_ns);
		for(int i = 0; i < $size(DATA); i++) begin
			// QUIET
			repeat(3) begin
				rx = 1;
				#(BIT_ns);
			end

			// START
			rx = 0;
			#(BIT_ns);

			// DATA
			for(int j = 0; j < 8; j++) begin
				rx = DATA[i][j];
				#(BIT_ns);
			end

			// STOP
			repeat(5) begin
				rx = 1;
				#(BIT_ns);
			end
			
			$display("DATA = %02x", DATA[i]);
		end
		$stop();
	end

   UART_Rec uart_rec(.clk(clk), .rx(rx), .data(data), .data_valid(data_valid));

   
   
endmodule
