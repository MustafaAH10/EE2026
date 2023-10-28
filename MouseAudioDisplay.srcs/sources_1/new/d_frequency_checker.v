`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2023 11:09:45 AM
// Design Name: 
// Module Name: frequency_checker
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
// Create Date: 29.10.2022 12:53:57
// Design Name: 
// Module Name: freq_cnt
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


module d_frequency_checker(
        input clock, 
        input [11:0] sample, 
        input enable,
        input [11:0] fpeak_value_in, 
        output [15:0] df_led,
        output reg is_frequency
       
    );
    // zero crossing frequency counter
    // all LEDs turn on when freq more than 1000hz
    
    reg [31:0] sample_period_count;    
    reg [15:0] crosses;
    reg [15:0] final_frequency;
    reg [15:0] final_frequency_output;
    reg upwards; //maybe use to determine dxn
    initial begin
        upwards = 1;
    end
    
    reg [15:0] led;
    assign df_led = led;

    wire clock25khz;
    d_flexible_clock (clock, 1999, clock25khz);
    
    always @ (posedge clock25khz) begin
            if (enable == 1)
            begin
                sample_period_count = (sample_period_count == 125)? 0: sample_period_count + 1; 
                // sample a range of values
                if(fpeak_value_in > 2300) 
                begin
                    if(sample >= fpeak_value_in/2 && upwards == 1) 
                    begin
                        crosses <= (crosses == 16'b1111_1111_1111_1111)? crosses: crosses + 1;
                        upwards <= 0;
                    end
                    else if (sample <= fpeak_value_in/2 && upwards == 0) 
                    begin
                        crosses <= (crosses == 16'b1111_1111_1111_1111)? crosses: crosses  + 1;
                        upwards <= 1;     
                    end
                end

                if(sample_period_count == 0) 
                begin
                    final_frequency <= crosses*200/2;
                    crosses <= 0;
                end
                
                final_frequency_output <= final_frequency;                
     
                if (final_frequency_output > 1000) 
                begin
                    is_frequency <= 1;
                    led <= 16'b1111111111111111;    
                end
                else if (final_frequency_output < 1000)
                begin
                    is_frequency <= 0;
                    led <= 16'b0000000000000000;
                end
            end
            
            else if (enable == 0)
            begin
                is_frequency <= 0;
                led <= 16'b0000000000000000;
            end
    
        end
 
endmodule




