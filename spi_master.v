`timescale 1ns/1ps

module spi_master #( parameter CLK_FREQ = 50_000_000, SPI_FREQ = 5_000_000, DATA_WIDTH = 8)
  ( input clk, rst_n, start, miso,
    input [DATA_WIDTH-1:0] data_in,
    output reg sclk, cs_n, done,
    output mosi,
    output reg [DATA_WIDTH-1:0] data_out
  );
  
	// Clock Divider
	localparam DIVIDER = CLK_FREQ/(2*SPI_FREQ);
	reg [$clog2(DIVIDER)-1:0] clk_count;
	wire clk_tick;

	assign clk_tick = (clk_count == DIVIDER-1);

  	always @(posedge clk or negedge rst_n) begin
    	if(!rst_n)
        	clk_count <= 0;
    	else if(cs_n)
        	clk_count <= 0;
    	else if(clk_tick)
        	clk_count <= 0;
    	else
        	clk_count <= clk_count + 1;
	end

	// Sclk generation
  	always @(posedge clk or negedge rst_n) begin
    	if(!rst_n)
        	sclk <= 0;
        else if(cs_n)
            sclk <= 0;
    	else if(clk_tick)
        	sclk <= ~sclk;
	end

	// Edge Detection
	reg sclk_d;
	wire sclk_rise, sclk_fall;
  
  	always @(posedge clk or negedge rst_n) begin
    	if(!rst_n)
        	sclk_d <= 0;
    	else
        	sclk_d <= sclk;
	end

	assign sclk_rise = (~sclk_d) & sclk;
	assign sclk_fall = sclk_d & (~sclk);


	// FSM
	localparam IDLE  = 2'd0, LOAD  = 2'd1, SHIFT = 2'd2, DONE  = 2'd3;
	reg [1:0] state;
  	reg [DATA_WIDTH-1:0] tx_shift, rx_shift; 
	reg [2:0] bit_count;

	assign mosi = tx_shift[DATA_WIDTH-1];

  	always @(posedge clk or negedge rst_n) begin
      	if(!rst_n) begin
        	state <= IDLE;
        	cs_n <= 1'b1;
        	done <= 1'b0;
        	tx_shift <= 0;
        	rx_shift <= 0;
        	data_out <= 0;
	        bit_count <= 0;
    	end

    	else begin          
        	done <= 1'b0;
          
        	case(state)
              
        		IDLE: begin
            		cs_n <= 1'b1;
            		if(start)
                		state <= LOAD;
        		end

        
        		LOAD: begin
            		cs_n <= 1'b0;
            		tx_shift <= data_in;
            		rx_shift <= 0;
            		bit_count <= 0;
            		state <= SHIFT;
        		end
                      
              SHIFT: begin
                 // Shifting 
                 if (sclk_fall) begin
                    tx_shift <= {tx_shift[DATA_WIDTH-2:0], 1'b0};
                 end
                // Sampling
                 if (sclk_rise) begin
                    rx_shift <= {rx_shift[DATA_WIDTH-2:0], miso};     
                    if (bit_count == DATA_WIDTH-1) begin
                        state <= DONE;
                    end    
                    bit_count <= bit_count + 1;
                 end
              end
                
             DONE: begin
                cs_n     <= 1'b1;
                done     <= 1'b1;
                data_out <= rx_shift;
                state    <= IDLE;
             end          
        	endcase
    	end
	end 

endmodule