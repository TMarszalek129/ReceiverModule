module UART_Rec(
    input clk,
    input rx,
    output reg [7:0] data,
    output reg data_valid
);

   // independent parameters                                        
   parameter CLK_Hz        = 66_000_000.0; 
   parameter BITRATE_bps   = 9_600.0;  

   // derived parameters
   parameter BIT_clk = CLK_Hz / BITRATE_bps;

   enum {IDLE, START, BUSY, STOP} e_state = IDLE;
   reg [3:0]  frame_ctr = 0;
   reg [20:0] clock_ticks = 0;
   int i = 0;
   reg rx_z1 = 0;
   reg tick_tock = 0;

   always @(posedge clk) begin
	case(e_state)

	IDLE: begin
    i = 0;
	if(rx != rx_z1) begin
		e_state = START;
        frame_ctr = frame_ctr + 1;
        clock_ticks = 0;
		end
	end

    START: begin
       clock_ticks = clock_ticks + 1;

       if(clock_ticks == int'(BIT_clk)) begin
            e_state = BUSY;
            clock_ticks = 0;
       end
    end

	BUSY: begin
		clock_ticks = clock_ticks + 1;
        
        if(clock_ticks == int'(0.5 * BIT_clk)) begin
            data[i] = rx;
            i = i + 1;
        end

        if(clock_ticks == int'(BIT_clk)) begin
            clock_ticks = 0;
            tick_tock = ~tick_tock;
        end

        if(i == 8) begin
            e_state = STOP;
            clock_ticks = 0;
            data_valid = 1;
        end
		
	end

    STOP: begin
        clock_ticks = clock_ticks + 1;
        data_valid = 0;       

        if(clock_ticks == int'(5 * BIT_clk)) begin
            e_state = IDLE;
            clock_ticks = 0;
        end
    end

	endcase
    rx_z1 = rx;
   end

endmodule