`timescale 1ns / 1ps

module spi_slave #(parameter DATA_WIDTH = 8)
(   input sclk,
    input cs_n,
    input mosi,
    output miso
);

    reg [DATA_WIDTH-1:0] tx_shift = 8'h3C;
    reg [DATA_WIDTH-1:0] rx_shift = 0;

    assign miso = tx_shift[DATA_WIDTH-1];

    always @(negedge sclk or posedge cs_n) begin
        if(cs_n)
            tx_shift <= 8'h3C; // Data to be transferred is initialized before it is selected
        else
            tx_shift <= {tx_shift[DATA_WIDTH-2:0],1'b0}; // after it is selected it is shifted
    end

    always @(posedge sclk or posedge cs_n) begin
        if(cs_n)
            rx_shift <= 0;
        else
            rx_shift <= {rx_shift[DATA_WIDTH-2:0],mosi};
    end
    
endmodule

