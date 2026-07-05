`timescale 1ns/1ps

module tb_spi #(parameter CLK_FREQ = 50000000,
                SPI_FREQ = 5000000,
                DATA_WIDTH = 8);

    reg clk, rst_n, start;
    reg [7:0] data_in;
    wire sclk, cs_n, mosi, miso, done;
    wire [7:0] data_out;

    spi_master #(.CLK_FREQ(CLK_FREQ), .SPI_FREQ(SPI_FREQ), .DATA_WIDTH(DATA_WIDTH)) 
    dut (   .clk(clk),
            .rst_n(rst_n),
            .start(start),
            .miso(miso),
            .data_in(data_in),
            .sclk(sclk),
            .cs_n(cs_n),
            .done(done),
            .mosi(mosi),
            .data_out(data_out)
        );

    spi_slave #(.DATA_WIDTH(DATA_WIDTH))
    slave ( .sclk(sclk),
            .cs_n(cs_n),
            .mosi(mosi),
            .miso(miso)
           );

    // 50 MHz Clk
    always #10 clk = ~clk;   

    task transfer(input [7:0] tx_data);
    begin
        data_in = tx_data;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        wait(done);        
        $display("Time = %0t, Master Sent = %h, Master Received = %h", $time, data_in, data_out);
        repeat(5) @(posedge clk);   
    end
    endtask

    initial begin
        clk     = 0;
        rst_n   = 0;
        start   = 0;
        data_in = 8'h00;
        #50;
        rst_n = 1;

        // Inputs
        transfer(8'hA5);
        transfer(8'h3C);
        transfer(8'hF0);
        transfer(8'h55);
        transfer(8'h81);

        #200;
        $finish;
    end

endmodule