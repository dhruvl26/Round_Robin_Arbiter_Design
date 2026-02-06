`timescale 1ns/1ps

module tb_rr_arbiter;

    reg clk;
    reg rst;
    reg [3:0] req;
    wire [3:0] gnt;

    rr_arbiter dut (
        .clk(clk),
        .rst(rst),
        .req(req),
        .gnt(gnt)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial 
    begin
        rst = 1;
        req = 4'b0000;

        #20;
        rst = 0;

        #20;
        req = 4'b0000;

        #20;
        req = 4'b0001;   // R0
        #20;
        req = 4'b0000;

        #20;
        req = 4'b0010;   // R1
        #20;
        req = 4'b0000;

        #20;
        req = 4'b0111;   // R0, R1, R2 active
        #60;

        req = 4'b1111;
        #80;

        req = 4'b1010;
        #40;
        req = 4'b0101;
        #40;

        req = 4'b0000;
        #40;

        $finish;
    end

    initial begin
        $monitor("T=%0t | req=%b | gnt=%b", $time, req, gnt);
    end

endmodule