`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2023 21:57:17
// Design Name: 
// Module Name: clk6p25m
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module clk6p25m(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 7) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule

module clk10hz(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 4999999) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule

module clk20hz(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 2599999) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule

module clock10k(
input CLOCK, output reg NEW_CLOCK = 0
    );
    reg [31:0] COUNT = 0;
    always @ (posedge CLOCK) begin
        COUNT <= (COUNT == 4999) ? 0 : COUNT + 1;
        NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
    end
endmodule

module my_380hz_clock(
    input CLOCK,
    output reg my_clock = 0
    );
    
    reg [31:0] COUNT = 0;
    
    always @ (posedge CLOCK)
    begin
        COUNT <= (COUNT == 131578) ? 0 : COUNT + 1;
        my_clock <= (COUNT == 0) ? ~my_clock : my_clock;
    end
endmodule

module my_190hz_clock(
    input CLOCK,
    output reg my_clock = 0
    );
    
    reg [31:0] COUNT = 0;
    
    always @ (posedge CLOCK)
    begin
        COUNT <= (COUNT == 263157) ? 0 : COUNT + 1;
        my_clock <= (COUNT == 0) ? ~my_clock : my_clock;
    end
endmodule

module my_10Hz_clock (input CLOCK, output reg my_clock = 0);
    reg [31:0] COUNT = 0;
    
    always @ (posedge CLOCK) 
    begin
        COUNT <= (COUNT == 4999999) ? 0 : COUNT + 1; 
        my_clock <= (COUNT == 0) ? ~my_clock : my_clock;
    end
endmodule

module my_50Mhz_clock(
    input CLOCK,
    output reg my_clock = 0
    );
    
    reg [31:0] COUNT = 0;
    
    always @ (posedge CLOCK)
    begin
        COUNT <= (COUNT == 1) ? 0 : COUNT + 1;
        my_clock <= (COUNT == 0) ? ~my_clock : my_clock;
    end
endmodule

module my_20khz_clock(
    input CLOCK,
    output reg my_clock = 0
    );
    
    reg [31:0] COUNT = 0;
    
    always @ (posedge CLOCK)
    begin
        COUNT <= (COUNT == 2499) ? 0 : COUNT + 1;
        my_clock <= (COUNT == 0) ? ~my_clock : my_clock;
    end
endmodule


//module clk1hz(input CLOCK, output reg NEW_CLOCK = 0);
//    reg [31:0] COUNT = 0;
//        always @ (posedge CLOCK) begin
//            COUNT <= (COUNT == 50000000) ? 0 : COUNT + 1;
//            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
//        end
//endmodule


module clk10khz(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 5000) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule




module med_clock(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 3500000) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule

module hard_clock(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 2200000) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule

module cust_clock(input CLOCK, output reg NEW_CLOCK = 0);
    reg [31:0] COUNT = 0;
        always @ (posedge CLOCK) begin
            COUNT <= (COUNT == 3000000) ? 0 : COUNT + 1;
            NEW_CLOCK <= (COUNT == 0) ? ~NEW_CLOCK : NEW_CLOCK;
        end
endmodule

