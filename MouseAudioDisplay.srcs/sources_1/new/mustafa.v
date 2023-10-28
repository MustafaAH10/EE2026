`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2023 14:39:14
// Design Name: 
// Module Name: mustafa
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

module mustafa(
    input clk100M,
    input clk190,
    input clk380,
    input btnC, 
    input btnL,
    input btnU,
    input [15:0] sw,
    input [1:0] islegitnum,
    input [3:0] thelegitnum,
    output [3:0] musanode,
    output [6:0] mussegment,
    //output [1:0] reset_islegitnum,
    output [11:0] audio_out
    );

    wire [11:0] indiv_task_audio;
    wire [11:0] group_task_audio;
    wire [11:0] indiv_improv_audio;
    //assign audio_out = (sw[11] == 1) ? individual_improvement_out : (valid == 1) ? group_task_out : individual_task_out;
    
    wire [10:0] keys = sw[11:1];
    assign audio_out = (sw[11] == 1 && sw[0] == 1) ? indiv_task_audio : (sw[11] == 1 && sw[0] == 0) ? indiv_improv_audio : group_task_audio;
    
    mus_indiv_task indiv_task(clk100M, clk190, clk380, btnC, sw[1], indiv_task_audio);
    //audio_group_task group_task(clk100M, clk190, islegitnum, thelegitnum, group_task_audio);
    mus_indiv_improv indiv_improv (clk100M, keys, btnL, btnU, musanode, mussegment, indiv_improv_audio);
    
endmodule   

//module audio_group_task(
//    input clk100M,
//    input clk190,
//    input [1:0] islegitnum,
//    input [3:0] thelegitnum,
//    ///output [1:0] reset_islegitnum,
//    output [11:0] group_task_audio
//    );

//    wire [31:0] sound_duration = thelegitnum * 10_000_000;
//    wire sound_on;
//    wire [11:0] signal_190;
    
//    play_beep play_beep(clk190, signal_190);
//    timer_duration beep_timer(islegitnum, clk100M, sound_duration, sound_on);
    
//    assign group_task_audio = (sound_on == 1) ? signal_190 : 0;
   
//endmodule

//module timer_duration(
//    input start,
//    input clk100M,
//    input [31:0] limit,
//    //output reg reset_islegitnum = 0,
//    output reg signal = 0
//);

//    reg [31:0] count = 0;
//    reg button_state = 0;

//    always @(posedge clk100M) begin
//        if (button_state == 0 && start == 1) begin
//            count <= 0;
//            signal <= 1;
//        end else if (signal == 1) begin
//            count <= count + 1;
//            if (count == limit) begin
//                //reset_islegitnum <= 1;
//                signal <= 0;
//            end
//        end
        
//        button_state <= start;
//    end

//endmodule

//module play_beep(
//    input clock,
//    output reg [11:0] signal
//    );
    
//    always @ (clock) begin
//        signal = (clock == 1) ? 12'hFFF : 0;
//    end
//endmodule

module mus_indiv_task(
    input clk100M,
    input clk190,
    input clk380,
    input btnC,
    input switch1,
    output reg [11:0] task_output
    );
    
    wire [1:0] play_beep;
    reg [3:0] counter_190Hz = 0;
    reg [3:0] counter_380Hz = 0;
    reg [3:0] task_id = 0;
    reg [3:0] count; 
    reg [1:0] audio_on;
    reg [1:0] toggle_sound;
    
    my_1second_counter(clk100M, btnC, play_beep);
    
    always @ (posedge clk190)
        begin
               if (counter_190Hz == 0)
               begin
                   counter_190Hz <= 1;
               end
               else 
               begin
                   counter_190Hz <= 0;
               end
         end
            
     always @ (posedge clk380)
     begin
           if (counter_380Hz == 0)
           begin
               counter_380Hz <= 2;
           end
           else 
           begin
               counter_380Hz <= 0;
          end
     end
           
         always @ (posedge clk100M)
         begin
            if (play_beep == 1)
            begin
                if (switch1 == 1)
                begin
                  task_id <= counter_190Hz;
                end
                else if (switch1 == 0)
                begin
                  task_id <= counter_380Hz;
                end
              
                case(task_id)
                  0:
                  begin
                    task_output <= 12'b000000000000;                       
                  end                
                  1: 
                  begin    
                    task_output <= 12'hFFF;                     
                  end
                  2:
                  begin 
                    task_output <= 12'h800;                        
                  end
                endcase
            end
        end
    
endmodule

module my_1second_counter(
    input CLOCK,
    input btnC,
    output reg [1:0] play_beep
    );
    
//    reg [1:0] btnC_pressed;
    reg [2:0] task_number = 0;
    reg [1:0] current_count = 0;
          
    wire [3:0] clock_1Hz; 
    my_1hz_clock unit_clock_1Hz(CLOCK, clock_1Hz);
    
    always @ (posedge CLOCK)
    begin
        if (btnC == 1)
        begin
            if(current_count == 0)
            begin
                task_number <= 2;
            end
            else
            begin
                task_number <= 1;
            end
        end
        else
        begin
            task_number <= 0;
        end
    end
    
    always @ (posedge clock_1Hz)
    begin
       case (task_number)
       2:
       begin
            play_beep <= 1;
            current_count <= current_count + 1;
       end
       1:
       begin
            play_beep <= 0;
            current_count <= 1;
       end
       0:
       begin
            play_beep <= 0;
            current_count <= 0;    
       end
       endcase
    end
endmodule

module mus_indiv_improv(
    input clk100M,
    input [10:0] keys,
    input btnL,
    input btnU,
    output reg [3:0] musanode = 0, 
    output reg [6:0] mussegment = 0,
    output reg [11:0] output_signal = 0
    );

    wire [11:0] piano_out;
    wire[3:0] piano_an;
    wire[6:0]piano_seg;
    piano piano(clk100M, keys, piano_an, piano_seg, piano_out);
    
    wire [11:0] tt_out;
    wire[3:0] tt_an;
    wire[6:0] tt_seg;
    twinkle twinkle(clk100M, btnL, tt_an, tt_seg, tt_out);
    
    wire [11:0] bb_out;
    wire[3:0] bb_an;
    wire[6:0] bb_seg;
    baabaa baabaa(clk100M, btnU, bb_an, bb_seg, bb_out);
        
    always @ (posedge clk100M)
    begin
        if (keys[10] == 1 && btnL == 1) 
        begin
            output_signal <= 100 * tt_out;
            musanode <= tt_an;
            mussegment <= tt_seg;
        end
        else if (keys[10] == 1 && btnU == 1) 
        begin
            output_signal <= 100 * bb_out;
            musanode <= bb_an;
            mussegment <= bb_seg;
        end
        else if (keys[10] == 1)
        begin
            output_signal <= 100 * piano_out;
            musanode <= piano_an;
            mussegment <= piano_seg;
        end
    end
endmodule

module triwave(
    input clk,
    output reg [11:0] chord = 0
    );
    
    reg posstate = 1;
    always @ (posedge clk) begin
        if (chord == 0) 
            posstate = 1;
        if (chord == 100)
            posstate = 0;
        if (posstate == 1) chord = chord + 1;
        else chord = chord - 1;
    end
endmodule

module baabaa(
    input clk100M,
    input btnU,
    output reg [3:0] bb_an, 
    output reg [6:0] bb_seg,
    output reg [11:0] bb_out = 0
    );
    
    wire clkC; wire [11:0] C_chord;
    wire clkG; wire [11:0] G_chord;
    wire clkA; wire [11:0] A_chord; 
    wire clkF; wire [11:0] F_chord;
    wire clkE; wire [11:0] E_chord;
    wire clkD; wire [11:0] D_chord;
        
    var_clock clock_C(clk100M, 956, clkC);
    triwave C(clkC, C_chord);
        
    var_clock clock_G(clk100M, 638, clkG);
    triwave G(clkG, G_chord);
        
    var_clock clock_A(clk100M, 568, clkA);
    triwave A(clkA, A_chord);
        
    var_clock clock_F(clk100M, 716, clkF);
    triwave F(clkF, F_chord);
        
    var_clock clock_E(clk100M, 758, clkE);
    triwave E(clkE, E_chord);
       
    var_clock clock_D(clk100M, 851, clkD);
    triwave D(clkD, D_chord);
    
    wire clk10;
    my_10Hz_clock unit_clock_10Hz (clk100M, clk10);
    reg [31:0] bb_count = 0;
    
    always @ (posedge clk10)
    begin
        if (btnU)
            if (bb_count == 107) bb_count = 0;
            else bb_count = bb_count + 1;
        else
            bb_count = 0;    
    end
    
    always @ (btnU)
    begin
        if (btnU)
        begin          
            if ((bb_count > 0 && bb_count < 5) ||(bb_count > 8 && bb_count < 13) || (bb_count > 102 && bb_count < 107))
            begin
                bb_out = C_chord;
                bb_an <= 4'b1110;
                bb_seg <= 7'b1000110;
            end
            else if ((bb_count > 16 && bb_count < 21) || (bb_count > 24 && bb_count < 29) || (bb_count > 54 && bb_count < 59))
            begin
                bb_out = G_chord;
                bb_an <= 4'b1110;
                bb_seg <= 7'b0010000;
            end
            else if ((bb_count > 32 && bb_count < 37) || (bb_count > 39 && bb_count < 43) || (bb_count > 44 && bb_count < 47) || (bb_count > 49 && bb_count < 52))
            begin 
                bb_out = A_chord; 
                bb_an <= 4'b1110;
                bb_seg <= 7'b0001000; 
            end
            else if ((bb_count > 59 && bb_count < 64) || (bb_count > 66 && bb_count < 71))
            begin
                bb_out = F_chord;
                bb_an <= 4'b1110;
                bb_seg <= 7'b0001110;
            end 
            else if ((bb_count > 74 && bb_count < 78) || (bb_count > 80 && bb_count < 84))
            begin
                bb_out = E_chord;
                bb_an <= 4'b1110;
                bb_seg <= 7'b0000110;
            end 
            else if ((bb_count > 87 && bb_count < 92) || (bb_count > 95 && bb_count < 100))
            begin
                bb_out = D_chord;
                bb_an <= 4'b1110;
                bb_seg <= 7'b0100001;
            end 
            else
            begin
                bb_out = 0;
                bb_an <= 4'b1111;
                bb_seg <= 7'b1111111;
            end            
        end
        else
        begin
            bb_out= 0;
            bb_an <= 4'b1111;
            bb_seg <= 7'b1111111;
        end
    end

endmodule

module twinkle(
    input clk100M,
    input btnL,
    output reg [3:0] tt_an, 
    output reg [6:0] tt_seg,
    output reg [11:0] tt_out = 0
    );
    
    wire clkC; wire [11:0] C_chord;
    wire clkG; wire [11:0] G_chord;
    wire clkA; wire [11:0] A_chord;
    wire clkF; wire [11:0] F_chord;
    wire clkE; wire [11:0] E_chord;
    wire clkD; wire [11:0] D_chord;
    
    var_clock clock_C(clk100M, 956, clkC);
    triwave (clkC, C_chord);
    
    var_clock clock_G(clk100M, 638, clkG);
    triwave G(clkG, G_chord);
    
    var_clock clock_A(clk100M, 568, clkA);
    triwave A(clkA, A_chord);
    
    var_clock clock_F(clk100M, 716, clkF);
    triwave F(clkF, F_chord);
    
    var_clock clock_E(clk100M, 758, clkE);
    triwave E(clkE, E_chord);
    
    var_clock clock_D(clk100M, 851, clkD);
    triwave D(clkD, D_chord);
    
    wire clk10;
    my_10Hz_clock unit_clock_10Hz (clk100M, clk10);
    reg [31:0] tt_count = 0;
    
    always @ (posedge clk10)
    begin
        if (btnL)
            if (tt_count == 102) tt_count = 0;
            else tt_count = tt_count + 1;
        else
            tt_count = 0;    
    end
    
    always @ (btnL)
    begin
        if (btnL)
        begin          
            if ((tt_count > 0 && tt_count < 5) ||(tt_count > 8 && tt_count < 13))
            begin
                tt_out = C_chord; 
                tt_an <= 4'b1110;
                tt_seg <= 7'b1000110;
            end
            else if ((tt_count > 16 && tt_count < 21) || (tt_count > 24 && tt_count < 29) || (tt_count > 48 && tt_count < 53) )
            begin
                tt_out = G_chord;
                tt_an <= 4'b1110;
                tt_seg <= 7'b0010000;
            end             
            else if ((tt_count > 32 && tt_count < 37) || (tt_count > 40 && tt_count < 45))
            begin    
                tt_out = A_chord;
                tt_an <= 4'b1110;
                tt_seg <= 7'b0001000; 
            end
            else if ((tt_count > 56 && tt_count < 61) || (tt_count > 64 && tt_count < 69))
            begin 
                tt_out = F_chord;
                tt_an <= 4'b1110;
                tt_seg <= 7'b0001110;
            end
            else if ((tt_count > 72 && tt_count < 77) || (tt_count > 80 && tt_count < 85)) 
            begin
                tt_out = E_chord;
                tt_an <= 4'b1110;
                tt_seg <= 7'b0000110;
            end
            else if ((tt_count > 88 && tt_count < 93) || (tt_count > 96 && tt_count < 101)) 
            begin
                tt_out = D_chord;
                tt_an <= 4'b1110;
                tt_seg <= 7'b0100001;
            end
            else
            begin
                tt_out = 0;
                tt_an <= 4'b1111;
                tt_seg <= 7'b1111111;
             end           
        end
        else
        begin
            tt_out= 0;
            tt_an <= 4'b1111;
            tt_seg <= 7'b1111111; 
        end
    end

endmodule

module piano(
    input clk100M,
    input [11:0] keys,
    output reg [3:0] piano_an, 
    output reg [6:0] piano_seg,
    output reg [11:0] piano_out = 0
    );
    
    wire clkB; wire [11:0] B_chord;
    wire clkAS; wire [11:0] Asharp_chord;
    wire clkA; wire [11:0] A_chord;
    wire clkGS; wire [11:0] Gsharp_chord;
    wire clkG; wire [11:0] G_chord;
    wire clkF; wire [11:0] F_chord;
    wire clkE; wire [11:0] E_chord;
    wire clkD; wire [11:0] D_chord;
    wire clkC; wire [11:0] C_chord;

    var_clock clock_C(clk100M, 956, clkC);
    triwave C(clkC, C_chord);

    var_clock clock_D(clk100M, 851, clkD);
    triwave D(clkD, D_chord);

    var_clock clock_E(clk100M, 758, clkE);
    triwave E(clkE, E_chord);

    var_clock clock_F(clk100M, 716, clkF);
    triwave F(clkF, F_chord);

    var_clock clock_G(clk100M, 638, clkG);
    triwave G(clkG, G_chord);

    var_clock clock_GS(clk100M, 602, clkGS);
    triwave GS(clkGS, Gsharp_chord);

    var_clock clock_A(clk100M, 568, clkA);
    triwave A(clkA, A_chord);

    var_clock clock_AS(clk100M, 536, clkAS);
    triwave AS(clkAS, Asharp_chord);

    var_clock clock_B(clk100M, 506, clkB);
    triwave B(clkB, B_chord);
    
    always @ (keys) begin
        piano_out = 0;
        if (keys[10] == 1 && keys[8] == 1) // switch 9
        begin
            piano_out = C_chord;
            piano_an <= 4'b1110;
            piano_seg <= 7'b1000110;
        end
        else if (keys[10] == 1 && keys[7] == 1) //switch 8
        begin
            piano_out = D_chord;
            piano_an <= 4'b1110;
            piano_seg <= 7'b0100001;
        end
        else if (keys[10] == 1 && keys[6] == 1) //switch 7
        begin
            piano_out = E_chord;
            piano_an <= 4'b1110;
            piano_seg <= 7'b0000110;
        end
        else if (keys[10] == 1 && keys[5] == 1) //switch 6
        begin
            piano_out = F_chord;
            piano_an <= 4'b1110;
            piano_seg <= 7'b0001110;
        end
        else if (keys[10] == 1 && keys[4] == 1) //switch 5
        begin
            piano_out = G_chord;
            piano_an <= 4'b1110;
            piano_seg <= 7'b0010000;
        end
        else if (keys[10] == 1 && keys[3] == 1) //switch 4
        begin 
            piano_out = A_chord;
            piano_an <= 4'b1110;
            piano_seg <= 7'b0001000;
        end
        else if (keys[10] == 1 && keys[2] == 1) //switch 3
        begin
            piano_out = Asharp_chord;
            piano_an <= 4'b1110;
            piano_seg <= 7'b0001000;
        end
        else if (keys[10] == 1 && keys[1] == 1) //switch 2
        begin
            piano_out = B_chord;
            piano_an <= 4'b1110;
            piano_seg <= 7'b0000011;
        end
        else 
        begin
            piano_out = 0;
            piano_an <= 4'b1111;
            piano_seg <= 7'b1111111; 
        end
        end    
endmodule

