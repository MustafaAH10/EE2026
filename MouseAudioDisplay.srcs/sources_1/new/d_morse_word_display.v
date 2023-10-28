`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2023 03:58:25 PM
// Design Name: 
// Module Name: morse_word_display
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


module d_morse_word_display(
    input clock, 
    input [39:0] seg_display,
    output reg [3:0] an, 
    output reg [6:0] seg,
    input enable
    );

    reg [1:0] an_step = 0;
    
//    wire clock200hz;
//    d_flexible_clock (clock, 249999, clock200hz);
    
    wire clock300hz;
    d_flexible_clock (clock, 166666, clock300hz);


    always @ (posedge clock300hz)
    begin
        if (enable == 1)
        begin
            // try display letter e                
            an_step <= an_step + 1;       // running 0 1 2 3 on repeat
            
            case (an_step)
            0:
            begin
                if (seg_display[39:30] == 10'b1011000000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0100000; 
                end
                
                else if (seg_display[39:30] == 10'b1110101000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0000011; 
                end
                
                else if (seg_display[39:30] == 10'b1110111000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0100111; 
                end
                
                else if (seg_display[39:30] == 10'b1110100000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0100001; 
                end
                
                else if (seg_display[39:30] == 10'b1000000000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0000110;
                end
                
                else if (seg_display[39:30] == 10'b1010111000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0001110; 
                end
                
                else if (seg_display[39:30] == 10'b1111100000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1000010; 
                end
                
                else if (seg_display[39:30] == 10'b1010101000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0001011; 
                end
                
                else if (seg_display[39:30] == 10'b1010000000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1101110; 
                end
                
                else if (seg_display[39:30] == 10'b1011111100) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1110010; 
                end
                
                else if (seg_display[39:30] == 10'b1110110000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0001010; 
                end
                
                else if (seg_display[39:30] == 10'b1011101000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1000111; 
                end
                
                else if (seg_display[39:30] == 10'b1111000000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0101010; 
                end
                
                else if (seg_display[39:30] == 10'b1110000000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0101011; 
                end
                
                else if (seg_display[39:30] == 10'b1111110000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0100011; 
                end
                
                else if (seg_display[39:30] == 10'b1011111000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0001100; 
                end
                
                else if (seg_display[39:30] == 10'b1111101100) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0011000; 
                end
                
                else if (seg_display[39:30] == 10'b1011100000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0101111; 
                end
                
                else if (seg_display[39:30] == 10'b1010100000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1010010; 
                end
                
                else if (seg_display[39:30] == 10'b1100000000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0000111; 
                end
                
                else if (seg_display[39:30] == 10'b1010110000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1100011; 
                end
                
                else if (seg_display[39:30] == 10'b1010101100) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1010101; 
                end
                
                else if (seg_display[39:30] == 10'b1011110000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0010101; 
                end
                
                else if (seg_display[39:30] == 10'b1110101100) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1101011; 
                end
                
                else if (seg_display[39:30] == 10'b1110111100) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0010001; 
                end
                
                else if (seg_display[39:30] == 10'b1111101000) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1100100; 
                end
                
                // letter ends here
                
                else if (seg_display[39:30] == 10'b1111111111) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1000000; 
                end
                
                else if (seg_display[39:30] == 10'b1011111111) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1111001; 
                end
                
                else if (seg_display[39:30] == 10'b1010111111) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0100100; 
                end
                
                else if (seg_display[39:30] == 10'b1010101111) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0110000; 
                end
                
                else if (seg_display[39:30] == 10'b1010101011) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0011001; 
                end
                
                else if (seg_display[39:30] == 10'b1010101010) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0010010; 
                end
                
                else if (seg_display[39:30] == 10'b1110101010) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0000010; 
                end
                
                else if (seg_display[39:30] == 10'b1111101010) 
                begin 
                    an = 4'b0111;
                    seg = 7'b1111000; 
                end
                
                else if (seg_display[39:30] == 10'b1111111010) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0000000; 
                end
                
                else if (seg_display[39:30] == 10'b1111111110) 
                begin 
                    an = 4'b0111;
                    seg = 7'b0010000; 
                end
                
                else 
                begin                         
                    an = 4'b1111;
                    seg = 7'b1111111;
                end
                
            end 
            
            1:
            begin 
                if (seg_display[29:20] == 10'b1011000000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0100000; 
                end
                
                else if (seg_display[29:20] == 10'b1110101000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0000011; 
                end
                
                else if (seg_display[29:20] == 10'b1110111000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0100111; 
                end
                
                else if (seg_display[29:20] == 10'b1110100000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0100001; 
                end
                
                else if (seg_display[29:20] == 10'b1000000000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0000110;
                end
                
                else if (seg_display[29:20] == 10'b1010111000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0001110; 
                end
                
                else if (seg_display[29:20] == 10'b1111100000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1000010; 
                end
                
                else if (seg_display[29:20] == 10'b1010101000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0001011; 
                end
                
                else if (seg_display[29:20] == 10'b1010000000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1101110; 
                end
                
                else if (seg_display[29:20] == 10'b1011111100) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1110010; 
                end
                
                else if (seg_display[29:20] == 10'b1110110000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0001010; 
                end
                
                else if (seg_display[29:20] == 10'b1011101000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1000111; 
                end
                
                else if (seg_display[29:20] == 10'b1111000000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0101010; 
                end
                
                else if (seg_display[29:20] == 10'b1110000000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0101011; 
                end
                
                else if (seg_display[29:20] == 10'b1111110000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0100011; 
                end
                
                else if (seg_display[29:20] == 10'b1011111000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0001100; 
                end
                
                else if (seg_display[29:20] == 10'b1111101100) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0011000; 
                end
                
                else if (seg_display[29:20] == 10'b1011100000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0101111; 
                end
                
                else if (seg_display[29:20] == 10'b1010100000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1010010; 
                end
                
                else if (seg_display[29:20] == 10'b1100000000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0000111; 
                end
                
                else if (seg_display[29:20] == 10'b1010110000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1100011; 
                end
                
                else if (seg_display[29:20] == 10'b1010101100) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1010101; 
                end
                
                else if (seg_display[29:20] == 10'b1011110000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0010101; 
                end
                
                else if (seg_display[29:20] == 10'b1110101100) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1101011; 
                end
                
                else if (seg_display[29:20] == 10'b1110111100) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0010001; 
                end
                
                else if (seg_display[29:20] == 10'b1111101000) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1100100; 
                end
                
                // letter ends here
                
                else if (seg_display[29:20] == 10'b1111111111) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1000000; 
                end
                
                else if (seg_display[29:20] == 10'b1011111111) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1111001; 
                end
                
                else if (seg_display[29:20] == 10'b1010111111) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0100100; 
                end
                
                else if (seg_display[29:20] == 10'b1010101111) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0110000; 
                end
                
                else if (seg_display[29:20] == 10'b1010101011) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0011001; 
                end
                
                else if (seg_display[29:20] == 10'b1010101010) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0010010; 
                end
                
                else if (seg_display[29:20] == 10'b1110101010) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0000010; 
                end
                
                else if (seg_display[29:20] == 10'b1111101010) 
                begin 
                    an = 4'b1011;
                    seg = 7'b1111000; 
                end
                
                else if (seg_display[29:20] == 10'b1111111010) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0000000; 
                end
                
                else if (seg_display[29:20] == 10'b1111111110) 
                begin 
                    an = 4'b1011;
                    seg = 7'b0010000; 
                end
                
                else 
                begin                         
                    an = 4'b1111;
                    seg = 7'b1111111;
                end
            end 
            
            2:
            begin 
                if (seg_display[19:10] == 10'b1011000000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0100000; 
                end
                
                else if (seg_display[19:10] == 10'b1110101000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0000011; 
                end
                
                else if (seg_display[19:10] == 10'b1110111000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0100111; 
                end
                
                else if (seg_display[19:10] == 10'b1110100000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0100001; 
                end
                
                else if (seg_display[19:10] == 10'b1000000000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0000110;
                end
                
                else if (seg_display[19:10] == 10'b1010111000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0001110; 
                end
                
                else if (seg_display[19:10] == 10'b1111100000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1000010; 
                end
                
                else if (seg_display[19:10] == 10'b1010101000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0001011; 
                end
                
                else if (seg_display[19:10] == 10'b1010000000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1101110; 
                end
                
                else if (seg_display[19:10] == 10'b1011111100) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1110010; 
                end
                
                else if (seg_display[19:10] == 10'b1110110000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0001010; 
                end
                
                else if (seg_display[19:10] == 10'b1011101000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1000111; 
                end
                
                else if (seg_display[19:10] == 10'b1111000000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0101010; 
                end
                
                else if (seg_display[19:10] == 10'b1110000000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0101011; 
                end
                
                else if (seg_display[19:10] == 10'b1111110000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0100011; 
                end
                
                else if (seg_display[19:10] == 10'b1011111000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0001100; 
                end
                
                else if (seg_display[19:10] == 10'b1111101100) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0011000; 
                end
                
                else if (seg_display[19:10] == 10'b1011100000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0101111; 
                end
                
                else if (seg_display[19:10] == 10'b1010100000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1010010; 
                end
                
                else if (seg_display[19:10] == 10'b1100000000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0000111; 
                end
                
                else if (seg_display[19:10] == 10'b1010110000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1100011; 
                end
                
                else if (seg_display[19:10] == 10'b1010101100) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1010101; 
                end
                
                else if (seg_display[19:10] == 10'b1011110000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0010101; 
                end
                
                else if (seg_display[19:10] == 10'b1110101100) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1101011; 
                end
                
                else if (seg_display[19:10] == 10'b1110111100) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0010001; 
                end
                
                else if (seg_display[19:10] == 10'b1111101000) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1100100; 
                end
                
                // letter ends here
                
                else if (seg_display[19:10] == 10'b1111111111) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1000000; 
                end
                
                else if (seg_display[19:10] == 10'b1011111111) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1111001; 
                end
                
                else if (seg_display[19:10] == 10'b1010111111) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0100100; 
                end
                
                else if (seg_display[19:10] == 10'b1010101111) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0110000; 
                end
                
                else if (seg_display[19:10] == 10'b1010101011) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0011001; 
                end
                
                else if (seg_display[19:10] == 10'b1010101010) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0010010; 
                end
                
                else if (seg_display[19:10] == 10'b1110101010) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0000010; 
                end
                
                else if (seg_display[19:10] == 10'b1111101010) 
                begin 
                    an = 4'b1101;
                    seg = 7'b1111000; 
                end
                
                else if (seg_display[19:10] == 10'b1111111010) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0000000; 
                end
                
                else if (seg_display[19:10] == 10'b1111111110) 
                begin 
                    an = 4'b1101;
                    seg = 7'b0010000; 
                end
                
                else 
                begin                         
                    an = 4'b1111;
                    seg = 7'b1111111;
                end
            end 
            
            3:
            begin 
                if (seg_display[9:0] == 10'b1011000000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0100000; 
                end
                
                else if (seg_display[9:0] == 10'b1110101000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0000011; 
                end
                
                else if (seg_display[9:0] == 10'b1110111000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0100111; 
                end
                
                else if (seg_display[9:0] == 10'b1110100000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0100001; 
                end
                
                else if (seg_display[9:0] == 10'b1000000000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0000110;
                end
                
                else if (seg_display[9:0] == 10'b1010111000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0001110; 
                end
                
                else if (seg_display[9:0] == 10'b1111100000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1000010; 
                end
                
                else if (seg_display[9:0] == 10'b1010101000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0001011; 
                end
                
                else if (seg_display[9:0] == 10'b1010000000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1101110; 
                end
                
                else if (seg_display[9:0] == 10'b1011111100) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1110010; 
                end
                
                else if (seg_display[9:0] == 10'b1110110000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0001010; 
                end
                
                else if (seg_display[9:0] == 10'b1011101000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1000111; 
                end
                
                else if (seg_display[9:0] == 10'b1111000000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0101010; 
                end
                
                else if (seg_display[9:0] == 10'b1110000000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0101011; 
                end
                
                else if (seg_display[9:0] == 10'b1111110000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0100011; 
                end
                
                else if (seg_display[9:0] == 10'b1011111000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0001100; 
                end
                
                else if (seg_display[9:0] == 10'b1111101100) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0011000; 
                end
                
                else if (seg_display[9:0] == 10'b1011100000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0101111; 
                end
                
                else if (seg_display[9:0] == 10'b1010100000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1010010; 
                end
                
                else if (seg_display[9:0] == 10'b1100000000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0000111; 
                end
                
                else if (seg_display[9:0] == 10'b1010110000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1100011; 
                end
                
                else if (seg_display[9:0] == 10'b1010101100) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1010101; 
                end
                
                else if (seg_display[9:0] == 10'b1011110000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0010101; 
                end
                
                else if (seg_display[9:0] == 10'b1110101100) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1101011; 
                end
                
                else if (seg_display[9:0] == 10'b1110111100) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0010001; 
                end
                
                else if (seg_display[9:0] == 10'b1111101000) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1100100; 
                end
                
                // letter ends here
                
                else if (seg_display[9:0] == 10'b1111111111) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1000000; 
                end
                
                else if (seg_display[9:0] == 10'b1011111111) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1111001; 
                end
                
                else if (seg_display[9:0] == 10'b1010111111) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0100100; 
                end
                
                else if (seg_display[9:0] == 10'b1010101111) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0110000; 
                end
                
                else if (seg_display[9:0] == 10'b1010101011) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0011001; 
                end
                
                else if (seg_display[9:0] == 10'b1010101010) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0010010; 
                end
                
                else if (seg_display[9:0] == 10'b1110101010) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0000010; 
                end
                
                else if (seg_display[9:0] == 10'b1111101010) 
                begin 
                    an = 4'b1110;
                    seg = 7'b1111000; 
                end
                
                else if (seg_display[9:0] == 10'b1111111010) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0000000; 
                end
                
                else if (seg_display[9:0] == 10'b1111111110) 
                begin 
                    an = 4'b1110;
                    seg = 7'b0010000; 
                end
                
                else 
                begin                         
                    an = 4'b1111;
                    seg = 7'b1111111;
                end
            end
            endcase
        end
        
        else if (enable == 0)
        begin
            an = 4'b1111;
            seg = 7'b1111111; 
        end
   

    end
endmodule
