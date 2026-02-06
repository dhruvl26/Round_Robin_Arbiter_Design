`timescale 1ns / 1ps
module rr_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] gnt
);

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        gnt = 4'b0000;
        next_state = state;   

        case (state)
            // Priority: R0 ? R1 ? R2 ? R3
            S0: begin
                if (req[0]) begin
                    gnt = 4'b0001;
                    next_state = S1;
                end
                else if (req[1]) begin
                    gnt = 4'b0010;
                    next_state = S2;
                end
                else if (req[2]) begin
                    gnt = 4'b0100;
                    next_state = S3;
                end
                else if (req[3]) begin
                    gnt = 4'b1000;
                    next_state = S0;
                end
            end

            // Priority: R1 ? R2 ? R3 ? R0
            S1: begin
                if (req[1]) begin
                    gnt = 4'b0010;
                    next_state = S2;
                end
                else if (req[2]) begin
                    gnt = 4'b0100;
                    next_state = S3;
                end
                else if (req[3]) begin
                    gnt = 4'b1000;
                    next_state = S0;
                end
                else if (req[0]) begin
                    gnt = 4'b0001;
                    next_state = S1;
                end
            end

            // Priority: R2 ? R3 ? R0 ? R1
            S2: begin
                if (req[2]) begin
                    gnt = 4'b0100;
                    next_state = S3;
                end
                else if (req[3]) begin
                    gnt = 4'b1000;
                    next_state = S0;
                end
                else if (req[0]) begin
                    gnt = 4'b0001;
                    next_state = S1;
                end
                else if (req[1]) begin
                    gnt = 4'b0010;
                    next_state = S2;
                end
            end

            // Priority: R3 ? R0 ? R1 ? R2
            S3: begin
                if (req[3]) begin
                    gnt = 4'b1000;
                    next_state = S0;
                end
                else if (req[0]) begin
                    gnt = 4'b0001;
                    next_state = S1;
                end
                else if (req[1]) begin
                    gnt = 4'b0010;
                    next_state = S2;
                end
                else if (req[2]) begin
                    gnt = 4'b0100;
                    next_state = S3;
                end
            end

        endcase
    end

endmodule