`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2023 03:11:20 PM
// Design Name: 
// Module Name: refined_morse_audio_input
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


module d_refined_morse_audio_input(
    input clock,
    input [11:0] sample,        // this is sample in 
    output reg sound_heard = 0,          // most impt
    input enable
    );
    
    wire clock20khz;
    d_flexible_clock (clock, 2499, clock20khz);
    
    reg [3:0] peak_intensity = 0;

    reg [31:0] count2000 = 0;
    reg [11:0] max = 0;

    always @ (posedge clock20khz) 
    begin
        if (enable == 1)
        begin
            count2000 <= (count2000 == 1999) ? 0 : count2000 + 1;
            max <= count2000 == 0 ? sample : (sample > max ? sample : max);
            if (count2000 == 0) 
            begin
                peak_intensity = max[10:7];
                if (peak_intensity == 4'd0) 
                begin
                    sound_heard <= 0;
                end
                else if (peak_intensity >= 4'd1 && peak_intensity <= 4'd2) 
                begin
                    sound_heard <= 0;
                end
                else if (peak_intensity >= 4'd3 && peak_intensity <= 4'd5) 
                begin
                    sound_heard <= 0;
                end
                else if (peak_intensity >= 4'd6 && peak_intensity <= 4'd8) 
                begin
                    sound_heard <= 1;
                end
                else if (peak_intensity >= 4'd9 && peak_intensity <= 4'd11) 
                begin
                    sound_heard <= 1;
                end
                else if (peak_intensity >= 4'd12 && peak_intensity <= 4'd15) 
                begin
                    sound_heard <= 1;
                end
            end
        end
    end
endmodule
