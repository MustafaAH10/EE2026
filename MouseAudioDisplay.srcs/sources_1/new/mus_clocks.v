`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2023 14:41:29
// Design Name: 
// Module Name: mus_clocks
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 23:35:24
// Design Name: 
// Module Name: clocks
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
module my_1hz_clock(
    input CLOCK,
    output reg my_clock = 0
    );
    
    reg [31:0] COUNT = 0;
    
    always @ (posedge CLOCK)
    begin
        COUNT <= (COUNT == 49999999) ? 0 : COUNT + 1;
        my_clock <= (COUNT == 0) ? ~my_clock : my_clock;
    end
endmodule

module var_clock(
    input clock,
    input [31:0] MAXCOUNT,
    output reg my_clock = 0
    );
    
    reg [31:0] count = 1;
    
    always @ (posedge clock) begin
        count = (count == MAXCOUNT) ? 1 : count + 1;
        my_clock = (count == 1) ? ~my_clock : my_clock;
    end
endmodule
