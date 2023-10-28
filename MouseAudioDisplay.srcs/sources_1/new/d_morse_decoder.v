`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2023 12:54:27 PM
// Design Name: 
// Module Name: morse_decoder
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


module d_morse_decoder(
    input clock,
    input sw,
    input btnC,
    input sound_heard,
    input is_frequency,
    output [15:0] led,
    output [39:0] out_seg_display,
    input enable
//    output [39:0] seg
    );
    
    wire clock_20khz;
    d_flexible_clock (clock, 2499, clock_20khz);
    
    reg [39:0] seg_display;
    assign out_seg_display = seg_display;
    
    reg [4:0] pulse_count = 0;
    reg [9:0] morse_state = 0;
    
    reg isNextLetter = 0;
    
    assign led[15:14] = morse_state[9:8];
    assign led[12:11] = morse_state[7:6];
    assign led[9:8] = morse_state[5:4];
    assign led[6:5] = morse_state[3:2];
    assign led[3:2] = morse_state[1:0];
    
    reg [2:0] letter_count;     // so that it reaches to value 4 and stop doing anything until reset btn is pressed
    // NEED RESET TO RESET LETTER_COUNT AND SEG_DISPLAY AND MORSE STATE
    
    
    reg [31:0] sound_counter = 0;
    reg isListening = 0;
    
    always @ (posedge clock_20khz) 
    begin
//         if btnC is pressed, do full reset for this for all variables\

        if (enable == 1)
        begin
           if (btnC)
            begin
                pulse_count <= 0;
                morse_state <= 0;
                isNextLetter <= 0;
                letter_count <= 0;
                sound_counter <= 0;
                isListening <= 0;
                seg_display <= 0;
            end
                    
            if (sw == 1) begin
                // when switch on, prep to load in next letter
                isNextLetter <= 1;
                if (sound_heard && is_frequency) begin
                    sound_counter <= sound_counter + 1;
                    isListening <= 1;
                end else if (!sound_heard && !is_frequency) begin
                    isListening <= 0;
                end
        
                if (!isListening) begin
                    case(pulse_count) 
                        5'b00000: begin
                            if (sound_counter > 10000) begin
                                morse_state[9:8] <= 2'b11;
                                pulse_count <= 5'b10000;
                            end else if (sound_counter > 3000) begin
                                morse_state[9:8] <= 2'b10;
                                pulse_count <= 5'b10000;
                            end
                        end
                        5'b10000: begin
                            if (sound_counter > 10000) begin
                                morse_state[7:6] <= 2'b11;
                                pulse_count <= 5'b11000;
                            end else if (sound_counter > 3000) begin
                                morse_state[7:6] <= 2'b10;
                                pulse_count <= 5'b11000;
                            end
                        end
                        5'b11000: begin
                            if (sound_counter > 10000) begin
                                morse_state[5:4] <= 2'b11;
                                pulse_count <= 5'b11100;
                            end else if (sound_counter > 3000) begin
                                morse_state[5:4] <= 2'b10;
                                pulse_count <= 5'b11100;
                            end
                        end
                        5'b11100: begin
                            if (sound_counter > 10000) begin
                                morse_state[3:2] <= 2'b11;
                                pulse_count <= 5'b11110;
                            end else if (sound_counter > 3000) begin
                                morse_state[3:2] <= 2'b10;
                                pulse_count <= 5'b11110;
                            end
                        end
                        5'b11110: begin
                            if (sound_counter > 10000) begin
                                morse_state[1:0] <= 2'b11;
                                pulse_count <= 5'b11111;
                            end else if (sound_counter > 3000) begin
                                morse_state[1:0] <= 2'b10;
                                pulse_count <= 5'b11111;
                            end
                        end
                    endcase
                    sound_counter <= 0;
                end
            end
            else if (sw == 0) begin
                pulse_count <= 5'b00000;
                if (morse_state != 10'b0000000000 && isNextLetter == 1) 
                begin
                    
                    case (letter_count) 
                    0: begin
                        letter_count <= letter_count + 1;
                        seg_display[39:30] = morse_state;
    //                    seg_display[39:30] <= 10'b1000000000;
                    end
                    1: begin
                        letter_count <= letter_count + 1;
                        seg_display[29:20] = morse_state;
    //                    seg_display[29:20] <= 10'b1000000000;
                    end
                    2: begin
                        letter_count <= letter_count + 1;
                        seg_display[19:10] = morse_state;
    //                    seg_display[19:10] <= 10'b1000000000;
                    end
                    3: begin
                        letter_count <= letter_count + 1;
                        seg_display[9:0] = morse_state;
    //                    seg_display[9:0] <= 10'b1000000000;
                    end
                    endcase
                    morse_state <= 0;
                    isNextLetter <= 0; // switch off isNextLetter and then prep for switch to be on again
                end
            end 
        end
        
        else if (enable == 0)
        begin
            pulse_count <= 0;
            morse_state <= 0;
            isNextLetter <= 0;
            letter_count <= 0;
            sound_counter <= 0;
            isListening <= 0;
            seg_display <= 0;
        end
    end
endmodule
