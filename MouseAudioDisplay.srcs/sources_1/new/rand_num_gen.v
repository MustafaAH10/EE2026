`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 13:22:39
// Design Name: 
// Module Name: rand_num_gen
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


module rand_num_gen(
    input clock, reset, output reg [3:0] Q
    );
    
    reg [3:0] Q = 4'b0000;
        
        always @ (posedge clock, posedge reset)
        begin
            if (reset)
            begin
                Q <= 0;
            end
            else
            begin
                Q <= { Q[2:0], ~(Q[2]^Q[3]) } ;
            end
        end
endmodule
