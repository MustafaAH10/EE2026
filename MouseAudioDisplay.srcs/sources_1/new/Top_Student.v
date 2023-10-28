`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
   
    input btnR, input btnL, input clock, inout PS2Clk, inout PS2Data, input reset,  input [15:0] sw,
     output  [15:0]led , output  [3:2] an, output  [6:0] seg , output  dp, 
    
     output  [15:0] moled_data , input [12:0] pixel_index,
       input [7:0] out_x_pos, input [7:0] out_y_pos, input righttrigger, input lefttrigger, input colortrigger
       ,input [11:0] sample, output [11:0] audio_out, output [9:0] isout, output [25:0] letterout
        

    );
   
    wire [11:0]x_pos,y_pos;
    parameter RED = 16'hF800;
    parameter GREEN = 16'h07E0;
    parameter BLACK = 16'h0;
    parameter WHITE = ~BLACK;
    reg[1:0] remembercolor = 1'b0;
    reg[15:0] customcolor = 16'b0;
    

   
    
    //OLED CLOCK
    wire clk6p25m;
    wire clk10hz;
    wire frame_begin;
    
    clk6p25m clk6p25m_output (clock, clk6p25m);
    my_10Hz_clock clk10hz_output (clock, clk10hz) ; 
  
    reg [7:0] x,y ;
    reg [7:0] currx,curry ;
    
    reg [7:0]scaled_x_pos, scaled_y_pos;
    
    //scale the mouse output to the dimentions of oled pixel display
    
    reg [1:0] photonum = 2'b00;
   
    
    reg light15;
    
    //resisters to mix the drawing color
    reg[16:0] red0;
    reg[16:0] red1;
    reg[16:0] green0;
    reg[16:0] green1;
    reg[16:0] blue0;
    reg[16:0] blue1;
    reg[16:0] partycolor;
    
    wire [6:0] segment;
    wire [3:2] anode;
    wire dot;
    
    
    
   //ignore debouncing stuff first 
    wire rightbtn;
    wire leftbtn;
   
    
    //resgisters for the 7 seg display on the oled
    reg btmhor = 0;
    reg midhor = 0;
    reg tophor = 0;
    reg leftverttop = 0;
    reg leftvertbot = 0;
    reg rightverttop = 0;
    reg rightvertbot = 0;
    
    //regester boolean to save color
    reg [9:0] is = 10'b0;
    reg [25:0] letter = 0;
    assign isout = is;
    assign letterout = letter;
        
     reg [15:0] oled_data;
     assign moled_data = oled_data;
      
      wire [8:0] audio_led;
      wire clk20khz;
      wire [11:0] maudio_out;
      assign audio_out = maudio_out;
      my_20khz_clock unit_clock20khz (clock, clk20khz);    
      
//      displaycontrol(clock,light15, is, anode, segment, dot );
        displaycontrol(clock, clk20khz, sample, light15, is, anode, segment, dot);  // shows how loud surroundings is
        mainaudiocontrol(clock, sw[15], is, maudio_out, light15);  //plays the beep
      
//      assign [8:0]led = audio_led;
      
   
    reg newstate = 0;
    reg oldstate = 0;
    
    
    
            assign led[0] = audio_led[0];
         assign      led[1] = audio_led[1];
          assign    led[2] = audio_led[2];
          assign    led[3] = audio_led[3];
          assign    led[4] = audio_led[4];
          assign    led[5] = audio_led[5];
         assign     led[6] = audio_led[6];
          assign    led[7] = audio_led[7];
          assign    led[8] = audio_led[8];
             
          assign     led[15] = light15;
           
           
            assign        an = anode;
            assign      seg = segment;
            assign      dp = dot;

    
    always @ (posedge clock)// 
        begin
           
           
       // if (mastertrigger == 1) begin
                
         partycolor <= partycolor +1; 
         
         // code to change cursor colour 
         remembercolor = (colortrigger == 1)?  ~remembercolor : remembercolor;   
         x = pixel_index % 96;
         y = pixel_index / 96;
         scaled_x_pos =  96 - ((out_x_pos>95)? 95 : (out_x_pos<1)? 1 : out_x_pos)  ;
         scaled_y_pos = 64 - ((out_y_pos>63)? 63 : (out_y_pos<1)? 1 : out_y_pos) ; 
        
        
  
        
         //color mixer formula
         
         red0 <= (sw[0])? 16'b00111_000000_00000 : 16'b0;
         red1 <= (sw[1])? 16'b11000_000000_00000 : 16'b0;
         green0 <= (sw[2])? 16'b00000_00111_00000 : 16'b0;
         green1 <= (sw[3])? 16'b00000_110000_00000 : 16'b0;
         blue0 <= (sw[4])? 16'b00000_00000_00111 : 16'b0;
         blue1 <= (sw[5])? 16'b00000_000000_11000 : 16'b0;   
         customcolor <= red0 + red1 + green0 + green1 + blue0 + blue1;
         
          //draw and erase function
          
          //reset drawing function
          
          if(~sw[15]) begin
                    
                     btmhor <= 0;
                     midhor <= 0;
                     tophor <= 0;
                     leftverttop <= 0;
                     leftvertbot <= 0;
                     rightverttop <= 0;
                     rightvertbot <= 0;
                     is <= 10'b0;
                     light15 <= 0;
           end
                
         
                
                                 
         
         // lines below are to show the cursor and move the cursor on input
         if (x > scaled_x_pos-1 && x < scaled_x_pos+2 && y > scaled_y_pos-1 && y < scaled_y_pos+2)
                      oled_data <= (remembercolor) ? GREEN : WHITE;
         
   
         else if (btmhor == 1 && x>45 && x<86 && y> 16 && y<20) oled_data <= WHITE; 
         else if (midhor == 1 && x>45 && x<86 && y> 36 && y<40)  oled_data <= WHITE;   
         else if (tophor == 1 && x>45 && x<86 && y> 56 && y<60)  oled_data <= WHITE;                               
         else if (leftverttop == 1 && x>82 && x<86 && y> 36 && y<60)  oled_data <= WHITE;       
         else if (rightverttop == 1 &&  x>45 && x<49 && y> 36 && y<60)  oled_data <= WHITE; 
         else if (leftvertbot == 1 &&  x>82 && x<86 && y> 16 && y<40)  oled_data <= WHITE;  
         else if (rightvertbot == 1 && x>45 && x<49 && y> 16 && y<40)  oled_data <= WHITE;          
            
          else if (x > 29 && y == 8 && sw[9]) begin
                             oled_data <= GREEN;
                         end
          else if (x > 29 && y == 7 && sw[9]) begin
                          oled_data <= GREEN;
                      end
          else if (x > 29 && y == 6 && sw[9]) begin
                           oled_data <= GREEN;
                       end               
          else if (x == 30 && y >5 && sw[9] ) begin
                             oled_data <= GREEN;
                         end
          else if (x == 31 && y >5 && sw[9] ) begin
                              oled_data <= GREEN;
                          end
          else if (x == 29 && y >5 && sw[9] ) begin
                               oled_data <= GREEN;
                           end                                                      
        //show horizontal lines
                             else if (x > 44 && x < 87 && y == 16 && sw[8]) begin  oled_data <= WHITE;  end
                            else  if (x > 44 && x < 87 && y == 20 && sw[8]) begin  oled_data <= WHITE;  end
                            else  if (x > 44 && x < 87 && y == 36 && sw[8]) begin  oled_data <= WHITE;  end
                           else   if (x > 44 && x < 87 && y == 40 && sw[8]) begin  oled_data <= WHITE;  end
                          else    if (x > 44 && x < 87 && y == 56 && sw[8]) begin  oled_data <= WHITE;  end
                          else    if (x > 44 && x < 87 && y == 60 && sw[8]) begin  oled_data <= WHITE;  end
                  
                  
                          //show vertical lines
                          else    if (y > 15 && y < 61 && x == 45 && sw[8]) begin  oled_data <= WHITE;  end
                         else     if (y > 15 && y < 61 && x == 49 && sw[8]) begin  oled_data <= WHITE;  end
                         else     if (y > 15 && y < 61 && x == 82 && sw[8]) begin  oled_data <= WHITE;  end
                         else     if (y > 15 && y < 61 && x == 86 && sw[8]) begin  oled_data <= WHITE;  end

 
        else 
                    oled_data <= BLACK;
                    
                    
                    
        //fill the pixel with color
        if (lefttrigger) begin
                                            
                currx = scaled_x_pos;
                curry = scaled_y_pos;
                
                
               //fill the 7 segment box with white if it is clicked on 
                
               if ( currx>45 && currx<86 && curry> 16 && curry<20 && sw[8])  
                    btmhor <= 1;
                
                else if ( currx>45 && currx<86 && curry> 36 && curry<40 && sw[8]) 
                midhor <= 1;
                
                else if ( currx>45 && currx<86 && curry> 56 && curry<60 && sw[8]) 
                tophor <= 1;
                
                else if ( currx>45 && currx<49 && curry> 36 && curry<60 && sw[8]) 
                rightverttop = 1;
                
                else if ( currx>45 && currx<49 && curry> 16 && curry<40 && sw[8]) 
                rightvertbot = 1;
                
                else if ( currx>82 && currx<86 && curry> 36 && curry<60 && sw[8]) 
                leftverttop = 1;
                
                else if ( currx>82 && currx<86 && curry> 16 && curry<40 && sw[8]) 
                leftvertbot = 1;
                
          end
        
            x <= x+1;
            y <= y+1;
            

         
             is [0] <= (sw[8] && sw[15] && btmhor && ~midhor && tophor && leftverttop && leftvertbot && rightverttop && rightvertbot)? 1:0;
              is[1] <= (sw[8] && sw[15] && ~btmhor && ~midhor && ~tophor && ~leftverttop && ~leftvertbot && rightverttop && rightvertbot)? 1:0;
              is[2] <= (sw[8] && sw[15] && btmhor && midhor && tophor && ~leftverttop && leftvertbot && rightverttop && ~rightvertbot)? 1:0;
              is[3] <= (sw[8] && sw[15] && btmhor && midhor && tophor && ~leftverttop && ~leftvertbot && rightverttop && rightvertbot)? 1:0;
              is[4] <= (sw[8] && sw[15] && ~btmhor && midhor && ~tophor && leftverttop && ~leftvertbot && rightverttop && rightvertbot)? 1:0;
              is[5] <= (sw[8] && sw[15] && btmhor && midhor && tophor && leftverttop && ~leftvertbot && ~rightverttop && rightvertbot)? 1:0;
              is[6] <= (sw[8] && sw[15] && btmhor && midhor && tophor && leftverttop && leftvertbot && ~rightverttop && rightvertbot)? 1:0;
              is[7] <= (sw[8] && sw[15] && ~btmhor && ~midhor && tophor && ~leftverttop && ~leftvertbot && rightverttop && rightvertbot)? 1:0;
              is[8] <= (sw[8] && sw[15] && btmhor && midhor && tophor && leftverttop && leftvertbot && rightverttop && rightvertbot)? 1:0;
              is[9] <= (sw[8] && sw[15] && btmhor && midhor && tophor && leftverttop && ~leftvertbot && rightverttop && rightvertbot)? 1:0;
             
            light15 <= is[0] || is[1] || is[2] || is[3] || is[4] || is[5] || is[6] || is[7] || is[8] || is[9] ;
            
            
            letter[0] <= (sw[8] && sw[15] && sw[7] && btmhor && midhor && tophor && ~leftverttop && leftvertbot && rightverttop && rightvertbot)? 1:0;
            letter[1] <= (sw[8] && sw[15] && sw[7] && btmhor && midhor && ~tophor && leftverttop && leftvertbot && ~rightverttop && rightvertbot)? 1:0;
            letter[2] <= (sw[8] && sw[15] && sw[7] && btmhor && midhor && ~tophor && ~leftverttop && leftvertbot && ~rightverttop && ~rightvertbot)? 1:0;
            letter[3] <= (sw[8] && sw[15] && sw[7] && btmhor && midhor && ~tophor && ~leftverttop && leftvertbot && rightverttop && rightvertbot)? 1:0;
            letter[4] <= (sw[8] && sw[15] && sw[7] && btmhor && midhor && tophor && leftverttop && leftvertbot && ~rightverttop && ~rightvertbot)? 1:0;
            letter[5] <= (sw[8] && sw[15] && sw[7] && ~btmhor && midhor && tophor && leftverttop && leftvertbot && ~rightverttop && ~rightvertbot)? 1:0;
            letter[6] <= (sw[8] && sw[15] && sw[7] && btmhor && ~midhor && tophor && leftverttop && leftvertbot && ~rightverttop && rightvertbot)? 1:0;
            letter[7] <= (sw[8] && sw[15] && sw[7] && ~btmhor && midhor && ~tophor && leftverttop && leftvertbot && ~rightverttop && rightvertbot)? 1:0;
            letter[8] <= (sw[8] && sw[15] && sw[7] && ~btmhor && ~midhor && tophor && ~leftverttop && leftvertbot && ~rightverttop && ~rightvertbot)? 1:0;
            letter[9] <= (sw[8] && sw[15] && sw[7] && btmhor && ~midhor && tophor && ~leftverttop && ~leftvertbot && ~rightverttop && rightvertbot)? 1:0;
            letter[10] <= (sw[8] && sw[15] && sw[7] && ~btmhor && midhor && tophor && leftverttop && leftvertbot && ~rightverttop && rightvertbot)? 1:0;
            letter[11] <= (sw[8] && sw[15] && sw[7] && btmhor && ~midhor && ~tophor && leftverttop && leftvertbot && ~rightverttop && ~rightvertbot)? 1:0;
            letter[12] <= (sw[8] && sw[15] && sw[7] && ~btmhor && midhor && tophor && ~leftverttop && leftvertbot && ~rightverttop && rightvertbot)? 1:0;
            letter[13] <= (sw[8] && sw[15] && sw[7] && ~btmhor && midhor && ~tophor && ~leftverttop && leftvertbot && ~rightverttop && rightvertbot)? 1:0;    
            letter[14] <= (sw[8] && sw[15] && sw[7] && btmhor && midhor && ~tophor && ~leftverttop && leftvertbot && ~rightverttop && rightvertbot)? 1:0;
            
            letter[15] <= (sw[8] && sw[15] && sw[7] && ~btmhor && midhor && tophor && leftverttop && leftvertbot && rightverttop && ~rightvertbot)? 1:0;
            
            letter[16] <= (sw[8] && sw[15] && sw[7] && ~btmhor && midhor && tophor && leftverttop && ~leftvertbot && rightverttop && rightvertbot)? 1:0;
            
            letter[17] <= (sw[8] && sw[15] && sw[7] && ~btmhor && midhor && ~tophor && ~leftverttop && leftvertbot && ~rightverttop && ~rightvertbot)? 1:0;
            
            letter[18] <= (sw[8] && sw[15] && sw[7] && btmhor && ~midhor && tophor && leftverttop && ~leftvertbot && ~rightverttop && rightvertbot)? 1:0;
            
            letter[19] <= (sw[8] && sw[15] && sw[7] && btmhor && midhor && ~tophor && leftverttop && leftvertbot && ~rightverttop && ~rightvertbot)? 1:0;
            
            letter[20] <= (sw[8] && sw[15] && sw[7] && btmhor && ~midhor && ~tophor && ~leftverttop && leftvertbot && ~rightverttop && rightvertbot)? 1:0;
            
            letter[21] <= (sw[8] && sw[15] && sw[7] && btmhor && ~midhor && ~tophor && leftverttop && ~leftvertbot && rightverttop && ~rightvertbot)? 1:0;
            
            letter[22] <= (sw[8] && sw[15] && sw[7] && btmhor && midhor && ~tophor && leftverttop && ~leftvertbot && rightverttop && ~rightvertbot)? 1:0;
            
            letter[23] <= (sw[8] && sw[15] && sw[7] && ~btmhor && ~midhor && ~tophor && ~leftverttop && leftvertbot && ~rightverttop && rightvertbot)? 1:0;
            
            letter[24] <= (sw[8] && sw[15] && sw[7] && btmhor && midhor && ~tophor && leftverttop && ~leftvertbot && rightverttop && rightvertbot)? 1:0;
            
            letter[25] <= (sw[8] && sw[15] && sw[7] && btmhor && ~midhor && tophor && ~leftverttop && leftvertbot && rightverttop && ~rightvertbot)? 1:0;
            
            
            
            
         end       //end clock

            
        
        
               


    
   
 //   end 
 

endmodule







// mouse output scaler to fit into display bits



module debouncer(input clock, clk100hz, data, output reg Q=0);
    always @ (posedge clock) begin
  if(clk100hz==1) 
           Q <= data;
    end
endmodule 


module mainaudiocontrol(
    input CLOCK,
    input sw15,
    input [9:0] is,
    output  [11:0] oaudio_out,
    input trigger
    
);
    
    wire clk190;    
    my_190hz_clock unit_clock_190hz(CLOCK, clk190); 
    
    wire my_10Hz_clock;
    my_10Hz_clock unit_clock_10Hz(CLOCK, my_10Hz_clock);
    
    reg [3:0] count; 
    reg [3:0] duration; 
    reg [15:0] current_switch; 
    reg [15:0] prev_switch; 
    reg [1:0] audio_on;
    reg [3:0] counter_190Hz;
    reg [1:0] toggle_sound;
    reg [11:0] audio_out;
    assign oaudio_out = audio_out;
    
    always @(posedge my_10Hz_clock) 
    begin


    if (trigger == 0) begin
        count <= 0;
        duration <= 0;
        current_switch <= 0;
        prev_switch <=0;
        audio_on <= 0;
        counter_190Hz <= 0;
        toggle_sound <= 0;
        

    end


    else if (trigger == 1) begin
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
        //prev_switch <= 0; 
        duration <= 0; // if no switch on, no beep
        count <= 0; // reset counter
      end
        
      if (current_switch == 0) begin
          audio_on <= 0; 
      end
      
      else if (count == duration && current_switch == prev_switch) // play finish sound alr
      begin
          audio_on <= 0; //Beep off if it was turned on for the current switch    
      end
      
      else if (count == duration && current_switch != prev_switch) 
      begin
        count <= 0; // reset counter
        audio_on <= 1; // Play beep when new switch has been turned on
      end
      
      else if (count != duration)  //continue playing
      begin
        audio_on <= 1; // Play beep if it was turned off for the current switch
        count <= count + 1; // increment counter
      end
      
      else 
      begin
        audio_on <= 0; //Beep off when no switch is on
        count <= 0; // reset counter
      end
      
      prev_switch <= current_switch; // update the current switch
      end

    end
        
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
           
    always @ (posedge CLOCK)
    begin
        if (audio_on == 0)
        begin
            audio_out <= 12'b000000000000;
        end
        else if (audio_on == 1)
        begin
            toggle_sound <= counter_190Hz;
            case(toggle_sound)
            0:
            begin
                audio_out <= 12'b000000000000;
            end
            1:
            begin
                audio_out <= 12'hFFF;
            end
            endcase
        end       
    end
    
endmodule




