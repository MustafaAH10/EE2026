`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2023 17:31:18
// Design Name: 
// Module Name: audiocontrol
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






module audiocontrol(
    input CLOCK,
    input sw15,
    input sw7,
    input sw0,
    input [9:0] is,
    input [25:0] letter,
    output  [11:0] oaudio_out
);

wire mclock;        // period 0.75s
 d_flexible_clock (CLOCK, 37999999, mclock);
 reg [6:0] mstate =0 ;
 reg startmorse = 0;
 wire [1:0] p1;
 wire [1:0] p2;
 wire [1:0] p3;
 wire [1:0] p4;
 wire [1:0] p5;
 reg [9:0] pulse = 0;
 
          assign p1 = pulse[9:8];
         assign p2 = pulse[7:6];
         assign p3 = pulse[5:4];
         assign p4 = pulse[3:2];
         assign p5 = pulse[1:0];
 
 
 wire clkA; 
 wire [11:0] A_chord;
 var_clock clock_A(CLOCK, 568, clkA);
 triwave A(clkA, A_chord);
 
 
 always @ (posedge mclock) begin
    if (sw0) 
        begin
            if (mstate == 30) 
            begin
                mstate <= mstate;
            end 
            else begin
            mstate <= mstate +1;
            end
        end 
    
    else 
        mstate <= 0;
        
 end
 
 
 reg [3:0] count;
  reg [3:0] duration;  
   wire my_10Hz_clock;
   
    wire clk190;    
    my_190hz_clock unit_clock_190hz(CLOCK, clk190); 
    
   
    my_10Hz_clock unit_clock_10Hz(CLOCK, my_10Hz_clock);
    
    
   
    reg [15:0] current_switch; 
    reg [15:0] prev_switch; 
    reg [1:0] audio_on;
    reg [3:0] counter_190Hz;
    reg [1:0] toggle_sound;
    reg [11:0] audio_out;
    
    
    assign oaudio_out = 100 * audio_out;
    
    
    
    always @ (posedge CLOCK) begin
         
         if (sw7) begin /////////////////////////////// morse code mode
                    
                   if (is[0]) begin
                      pulse <= 10'b1111111111;
                    end
                    else if (is[1]) begin
                      pulse <= 10'b1011111111;
                    end
                    else if (is[2]) begin
                      pulse <= 10'b1010111111;
                    end
                    else if (is[3]) begin
                      pulse <= 10'b1010101111; 
                    end
                    else if (is[4]) begin
                      pulse <= 10'b1010101011;
                    end
                    else if (is[5]) begin
                      pulse <= 10'b1010101010;
                    end
                    else if (is[6]) begin
                      pulse <= 10'b1110101010;
                    end
                    else if (is[7]) begin
                      pulse <= 10'b1111101010; 
                    end
                    else if (is[8]) begin
                      pulse <= 10'b1111111010;
                    end
                    else if (is[9]) begin
                      pulse <= 10'b1111111110; 
                     end

                    else if (letter[0]) begin
                      pulse <= 10'b1011000000; //a
                      end
                    
                    else if (letter[1]) begin
                      pulse <= 10'b1110101000; //b
                      end

                    else if (letter[2]) begin
                      pulse <= 10'b1110111000; //c
                      end

                    else if (letter[3]) begin
                      pulse <= 10'b1110100000;
                      end

                    else if (letter[4]) begin
                      pulse <= 10'b1000000000;
                      end          

                    else if (letter[5]) begin
                      pulse <= 10'b1010111000;
                      end
                    
                    else if (letter[6]) begin
                      pulse <= 10'b1111100000;
                      end

                    else if (letter[7]) begin
                      pulse <= 10'b1010101000;
                      end

                    else if (letter[8]) begin
                      pulse <= 10'b1010000000;
                      end

                    else if (letter[9]) begin
                       pulse <= 10'b1011111100;
                      end  

                    else if (letter[10]) begin
                      pulse <= 10'b1110110000;  // k
                      end
                    
                    else if (letter[11]) begin
                      pulse <= 10'b1011101000;
                      end

                    else if (letter[12]) begin
                      pulse <= 10'b1111000000; //m
                      end

                    else if (letter[13]) begin
                      pulse <= 10'b1110000000;  //n
                      end

                    else if (letter[14]) begin
                      pulse <= 10'b1111110000;
                      end  

                    else if (letter[15]) begin
                      pulse <= 10'b1011111000;
                      end
                    
                    else if (letter[16]) begin
                      pulse <= 10'b1111101100;   // q
                      end

                    else if (letter[17]) begin
                      pulse <= 10'b1011100000;
                      end

                    else if (letter[18]) begin
                      pulse <= 10'b1010100000;
                      end

                    else if (letter[19]) begin
                      pulse <= 10'b1100000000;
                      end  

                    else if (letter[20]) begin
                      pulse <= 10'b1010110000;
                      end
                    
                    else if (letter[21]) begin
                      pulse <= 10'b1010101100;
                      end

                    else if (letter[22]) begin
                      pulse <= 10'b1011110000;   //w
                      end
                   else if (letter[23]) begin
                      pulse <= 10'b1110101100;
                      end
			       else if (letter[24]) begin
                      pulse <= 10'b1110111100;
                      end
			       else if (letter[25]) begin
                      pulse <= 10'b1111101000;
                      end

                    end

    
    end
    
    
    always @(posedge my_10Hz_clock) 
    begin


     if (sw7 == 0 && sw0 == 0) begin

                      if (is[0]) begin
                        current_switch <= 1;
                        duration <= 1; 
                      end
                      else if (is[1]) begin
                        current_switch <= 2;
                        duration <= 2; 
                      end
                      else if (is[2]) begin
                        current_switch <= 3;
                        duration <= 3; 
                      end
                      else if (is[3]) begin
                        current_switch <= 4;
                        duration <= 4; 
                      end
                      else if (is[4]) begin
                        current_switch <= 5;
                        duration <= 5; 
                      end
                      else if (is[5]) begin
                        current_switch <= 6;
                        duration <= 6; 
                      end
                      else if (is[6]) begin
                        current_switch <= 7;
                        duration <= 7; 
                      end
                      else if (is[7]) begin
                        current_switch <= 8;
                        duration <= 8; 
                      end
                      else if (is[8]) begin
                        current_switch <= 9;
                        duration <= 9; 
                      end
                      else if (is[9]) begin
                        current_switch <= 10;
                        duration <= 10; 
                       end
                      else begin
                            current_switch <= 0;
                             duration <= 0; 
                      
                      end
       
     end //sw7 == 0
     
     else if (sw7) begin
        
     
                    if ( mstate == 1) begin //play p1
                            if (p1 == 2'b11) begin  //play 0.6 
                                current_switch <= 1;
                                duration <= 6; 
                                
                            end
                            else if (p1 == 2'b10) begin //play 0.3
                                current_switch <= 2;
                                duration <= 3;   
                            end
                            
                            else begin//dont play
                                startmorse <= 0;
                                current_switch <= 0;
                                duration <= 0; // if no switch on, no beep
                                 count <= 0;
                                 
                            end
                    
                    end
                    
                    else if ( mstate == 3) begin
                                    if (p2 == 2'b11) begin  //play 0.6 
                                        current_switch <= 3;
                                        duration <= 6; 
                                    end
                                    else if (p2 == 2'b10) begin //play 0.3
                                        current_switch <= 5;
                                        duration <= 3;   
                                    end
                                    
                                    else begin//dont play
                                        startmorse <= 0;
                                        current_switch <= 0;
                                        duration <= 0; // if no switch on, no beep
                                         count <= 0;
                                       
                                       
                                    end                   
                    
                    end
                    
                    else if ( mstate == 5) begin
                                   if (p3 == 2'b11) begin  //play 0.6 
                                        current_switch <= 7;
                                        duration <= 6; 
                                    end
                                    else if (p3 == 2'b10) begin //play 0.3
                                        current_switch <= 8;
                                        duration <= 3;   
                                    end
                                    
                                    else begin//dont play
                                        startmorse <= 0;
                                        current_switch <= 0;
                                        duration <= 0; // if no switch on, no beep
                                         count <= 0;
                                        
                                        
                                    end                   
                    
                    end
                    
                    
                    else if ( mstate == 7 ) begin
                               if (p4 == 2'b11) begin  //play 0.6 
                                    current_switch <= 10;
                                    duration <= 6; 
                                end
                                else if (p4 == 2'b10) begin //play 0.3
                                    current_switch <= 11;
                                    duration <= 3;   
                                end
                                
                                else begin//dont play
                                    startmorse <= 0;
                                    current_switch <= 0;
                                    duration <= 0; // if no switch on, no beep
                                     count <= 0;
                                    
                                   
                                end
                    
                    
                    end
                    
                    
                    else if ( mstate == 9) begin
                                if (p5 == 2'b11) begin  //play 0.6 
                                    current_switch <= 13;
                                    duration <= 6; 
                                end
                                else if (p5 == 2'b10) begin //play 0.3
                                    current_switch <= 14;
                                    duration <= 3;   
                                end
                                
                                else begin//dont play
                                    startmorse <= 0;
                                    current_switch <= 0;
                                    duration <= 0; // if no switch on, no beep
                                     count <= 0;
                
                                end                
                    
                    
                    
                    end
                    else begin
                                    startmorse <= 0;
                                    current_switch <= 0;
                                    duration <= 0; // if no switch on, no beep
                                     count <= 0;
                                    
                                    
                    
                    end

      
     end   // end sw7 == 1
       
      else begin
             current_switch <= 0;
             duration <= 0; // if no switch on, no beep
            count <= 0; // reset counter
             
           end
      
      
      
        
//      if (current_switch == 0) begin
//          audio_on <= 0; 
//      end
      
//      else if (count != duration)  //continue playing
//      begin
//          audio_on <= 1; // Play beep if it was turned off for the current switch
//          count <= count + 1; // increment counter
//      end
      
//      else if (count == duration && current_switch != prev_switch) 
//      begin
//        count <= 0; // reset counter
//        audio_on <= 1; // Play beep when new switch has been turned on
//      end
              
//      else if (count == duration && current_switch == prev_switch) // play finish sound alr
//      begin
//          audio_on <= 0; //Beep off if it was turned on for the current switch    
//      end
      
//      else begin
//        audio_on <= 0; //Beep off when no switch is on
//        count <= 0; // reset counter
//      end
      
//      prev_switch <= current_switch; // update the current switch
        
        
        // new try w mustafa part
        if (current_switch != prev_switch)
          begin
              count = 0;
          end
            
          if (current_switch == 0) begin
              audio_on = 0; 
          end
          
          else if (count < duration)  //continue playing
          begin
              audio_on = 1; // Play beep if it was turned off for the current switch
              count = count + 1; // increment counter
          end
                  
          else if (count == duration && current_switch == prev_switch) // play finish sound alr
          begin
              audio_on = 0; //Beep off if it was turned on for the current switch    
          end
          
          else begin
            audio_on = 0; //Beep off when no switch is on
            count = 0; // reset counter
          end
          
          prev_switch <= current_switch; // update the current switch

    end
        
        
//    always @ (posedge clk190)
//    begin
//           if (counter_190Hz == 0)
//           begin
//                counter_190Hz <= 1;
//           end
//           else 
//           begin
//               counter_190Hz <= 0;
//           end
//    end
           
//    always @ (posedge CLOCK)
//    begin
//        if (audio_on == 0)
//        begin
//            audio_out <= 12'b000000000000;
//        end
//        else if (audio_on == 1)
//        begin
//            toggle_sound <= counter_190Hz;
//            case(toggle_sound)
//            0:
//            begin
//                audio_out <= 12'b000000000000;
//            end
//            1:
//            begin
//                audio_out <= 12'hFFF;
//            end
//            endcase
//        end       
//    end
    
    
    // trying to output chord A even in normal group 
    always @ (posedge CLOCK)
    begin
        if (audio_on == 1)
        audio_out <= A_chord;
        
        else if ( audio_on == 0)
        audio_out <= 12'b000000000000;
    
    end
    
    
    
    
    
endmodule

