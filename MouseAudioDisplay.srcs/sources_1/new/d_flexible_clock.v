`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2023 11:11:29 PM
// Design Name: 
// Module Name: d_flexible_clock
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


module d_flexible_clock(input basys_clock, [31:0] my_m_value, output reg my_clk = 0);

    reg [31:0] count = 0;
    
    always @ (posedge basys_clock)
    begin
        count <= (count == my_m_value) ? 0 : count + 1;
        my_clk <= (count == 0) ? ~my_clk : my_clk;
    end
endmodule
