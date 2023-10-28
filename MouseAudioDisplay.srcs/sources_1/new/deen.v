`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2023 03:19:23 PM
// Design Name: 
// Module Name: deen_only
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


module deen(
    input clock, 
//    input sw11, 
//    input sw0,
    input [15:0] sw,   
    input btnC, 
    input [11:0] sample,
    input enable_morse,
    input enable_frequency_checker,
    input on_freq_led,
    input on_morse_led,
    output reg [15:0] deen_led,
    output [3:0] deen_an,
    output [6:0] deen_seg   
    );
    
    wire is_frequency;
    wire sound_heard;
    wire [39:0] seg_display;      // this is the raw 40 bit morse state data output from morse_decoder
    
    wire [15:0] dm_led;    
    wire [3:0] dm_an;
    wire [6:0] dm_seg;
    wire [15:0] df_led;
//    wire [3:0] df_an = 4'b1111;
    
//    assign deen_led = (enable_frequency_checker == 1 && enable_morse == 1) ? df_led : (enable_frequency_checker == 1 && enable_morse == 1)? dm_led;
//    assign deen_led = (sw[12] == 1 && sw [0] == 0) ? df_led : ((sw[12] == 1 && sw[0] == 1) ? dm_led :   );
    always @ (posedge clock)
    begin   
        if (on_freq_led == 1 && on_morse_led == 0)
        begin
            deen_led <= df_led;
        end
        
        else if (on_freq_led == 0 && on_morse_led == 1)
        begin
            deen_led <= dm_led;
        end 
        
    end
    
    assign deen_an = dm_an;
    assign deen_seg = dm_seg;
    
    d_morse_decoder (clock, sw[0], btnC, sound_heard, is_frequency, dm_led, seg_display, enable_morse);
    d_refined_morse_audio_input (clock, sample, sound_heard, enable_morse);
    d_morse_word_display (clock, seg_display, dm_an, dm_seg, enable_morse);
    
    reg [6:0] fpeak_counter;        // for 128
    reg [11:0] fpeak_value;
    reg [11:0] current_f_value;
    
    wire clock25khz;
    d_flexible_clock (clock, 1999, clock25khz);
    always @ (posedge clock25khz) begin
  // sample 
      fpeak_counter <= fpeak_counter + 1;  
      current_f_value <= sample;
      if (current_f_value > fpeak_value)
          fpeak_value <= current_f_value;
      if(fpeak_counter == 0 && sample < 2300)
          fpeak_value <= 0;
    end

    d_frequency_checker(clock, sample, enable_frequency_checker, fpeak_value, df_led, is_frequency);
    
    
    
    
endmodule
