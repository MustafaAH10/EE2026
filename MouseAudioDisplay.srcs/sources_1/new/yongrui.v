`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2023 14:32:01
// Design Name: 
// Module Name: yongrui
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
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

module yongrui (
    // Delete this comment and include Basys3 inputs and outputs here
    input btnR, input btnL, input clock, inout PS2Clk, inout PS2Data, input reset,  input [15:0] sw
    , output  [15:0]led , output  [3:0] an, output  [6:0] seg, output  [15:0] oled_data , output  [15:0] oled_data2
    , input [12:0] pixel_index, input [12:0] pixel_index2, input [7:0] out_x_pos, input [7:0] out_y_pos, input righttrigger, input lefttrigger, input colortrigger
    
    );
   
    wire [11:0]x_pos,y_pos;
    parameter RED = 16'hF800;
    parameter GREEN = 16'h07E0;
    parameter BLACK = 16'h0;
    parameter WHITE = ~BLACK; 
    parameter YELLOW = 16'b11111_111111_01101;  
    parameter ORANGE = 16'b11111_101010_00110;
     parameter BLUE = 16'b00101_011010_11000;
    reg[1:0] remembercolor = 1'b0;
    reg[15:0] customcolor = 16'b0;
    reg [5:0] count = 0;
    

    
      
       reg  [15:0]yled = 0 ;
       
       reg  [15:0] yoled_data = BLACK;
       reg  [15:0] yoled_data2 = BLACK;
       
       assign led = yled;
        reg[6:0] segment = 7'b111111;
          reg[3:0] anode = 4'b1111;
       
       assign an = anode;
       assign seg = segment;
       assign oled_data = yoled_data;
       assign oled_data2 = yoled_data2;
    

    
    //OLED CLOCK
    wire clk6p25m;
    wire clk10hz;
    wire clk20hz;
    wire clk10khz;
    wire frame_begin;
    wire mclock;
    wire hclock;
    wire cclock;
    
    clk6p25m clk6p25m_output (clock, clk6p25m);
    clk10hz clk10hz_output (clock, clk10hz) ; 
    clk20hz clk20hz_output (clock, clk20hz) ; 
    clk10khz clk10khz_output (clock, clk10khz) ; 
    
    med_clock (clock, mclock) ; 
    hard_clock (clock, hclock);
    cust_clock (clock, cclock);
   
    reg [7:0] x,y ;
    reg [7:0] x2,y2 ;
    
    reg [7:0]scaled_x_pos, scaled_y_pos;
    reg [7:0] scaled_y_pos2 = 32;
    reg [7:0] movingx = 90;
    reg [7:0] mmovingx = 90;
    reg [7:0] hmovingx = 90;
    reg [7:0] cmovingx = 90;
    
    
   
    
   
    reg [3:0] gamestate = 0;
    reg [3:0] gamestate2 = 0;
    
    //0 = menu , 1 == easy , 2 == medium , 3 == hard , 4 == custom , 5 == win, 6 == lose , 7 == runnining custom
   
    reg [6144:0]memory  = 6144'b0;
    
    reg[16:0] red0;
    reg[16:0] red1;
    reg[16:0] green0;
    reg[16:0] green1;
    reg[16:0] blue0;
    reg[16:0] blue1;
    reg[16:0] partycolor;
   
    reg[2:0] choice = 3'b0;
    reg dot = 1'b1;
    reg starteasyclock = 0;
    reg startmedclock = 0;
    reg starthardclock = 0;
    reg startcustclock = 0;
    reg showdisplay = 0;
    
    
    
  
     
     

    always @ (posedge clk10khz)
    begin
         if (count == 43)
            begin
                count <= 0;
            end
            else 
            begin
                count <= count + 1;
            end
    end   
    
    always @ (posedge clk20hz)  begin
    
    
        if (btnR) begin     
            scaled_y_pos2 <= scaled_y_pos2+1;      
        end
        
        if (btnL) begin 
            scaled_y_pos2 <= scaled_y_pos2-1;
        end
        
        if (scaled_y_pos2 >63) 
            scaled_y_pos2 <= 63;
            
        if (scaled_y_pos2 <1) 
            scaled_y_pos2 <= 1;
    
    end
    
  
    
    
    
    
     
    
    
    //always block to draw the image
    
    always @ (posedge clock) 
        begin
  
            yled[0] <= (gamestate == 0)? 1:0;
            yled[1] <= (gamestate == 1)? 1:0;
            yled[2] <= (gamestate == 2)? 1:0;
            yled[3] <= (gamestate == 3)? 1:0;
            yled[4] <= (gamestate == 4)? 1:0;
            yled[5] <= (choice == 1)? 1:0;
            yled[6] <= (choice == 2)? 1:0;
            yled[7] <= (choice == 3)? 1:0;
             yled[8] <= (choice == 4)? 1:0;    
            
       
         partycolor <= partycolor +1; 
         
         // code to change cursor colour 
         remembercolor = (colortrigger == 1)?  ~remembercolor : remembercolor;   
         x = pixel_index % 96;
         y = pixel_index / 96;
         x2 = pixel_index2 % 96;
         y2 = pixel_index2 / 96;
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
         
         
         if (~sw[13]) begin
         
          /// write the message here //////////////////////////////////////////////////////////////////////////
         
                        if (((96-x == 15 && 64-y == 10) || (96-x == 16 && 64-y == 10) || (96-x == 17 && 64-y == 10) || (96-x == 16 && 64-y == 11) || (96-x == 16 && 64-y == 12) || (96-x == 16 && 64-y == 13) || (96-x == 16 && 64-y == 14) || (96-x == 19 && 64-y == 10) || (96-x == 22 && 64-y == 10) || (96-x == 19 && 64-y == 11) || (96-x == 22 && 64-y == 11) || (96-x == 19 && 64-y == 12) || (96-x == 22 && 64-y == 12) || (96-x == 19 && 64-y == 13) || (96-x == 22 && 64-y == 13) || (96-x == 20 && 64-y == 14) || (96-x == 21 && 64-y == 14) || (96-x == 24 && 64-y == 10) || (96-x == 25 && 64-y == 10) || (96-x == 26 && 64-y == 10) || (96-x == 24 && 64-y == 11) || (96-x == 27 && 64-y == 11) || (96-x == 24 && 64-y == 12) || (96-x == 25 && 64-y == 12) || (96-x == 26 && 64-y == 12) || (96-x == 24 && 64-y == 13) || (96-x == 26 && 64-y == 13) || (96-x == 24 && 64-y == 14) || (96-x == 27 && 64-y == 14) || (96-x == 29 && 64-y == 10) || (96-x == 32 && 64-y == 10) || (96-x == 29 && 64-y == 11) || (96-x == 30 && 64-y == 11) || (96-x == 32 && 64-y == 11) || (96-x == 29 && 64-y == 12) || (96-x == 31 && 64-y == 12) || (96-x == 32 && 64-y == 12) || (96-x == 29 && 64-y == 13) || (96-x == 32 && 64-y == 13) || (96-x == 29 && 64-y == 14) || (96-x == 32 && 64-y == 14) || (96-x == 36 && 64-y == 10) || (96-x == 37 && 64-y == 10) || (96-x == 35 && 64-y == 11) || (96-x == 38 && 64-y == 11) || (96-x == 35 && 64-y == 12) || (96-x == 38 && 64-y == 12) || (96-x == 35 && 64-y == 13) || (96-x == 38 && 64-y == 13) || (96-x == 36 && 64-y == 14) || (96-x == 37 && 64-y == 14) || (96-x == 40 && 64-y == 10) || (96-x == 43 && 64-y == 10) || (96-x == 40 && 64-y == 11) || (96-x == 41 && 64-y == 11) || (96-x == 43 && 64-y == 11) || (96-x == 40 && 64-y == 12) || (96-x == 42 && 64-y == 12) || (96-x == 43 && 64-y == 12) || (96-x == 40 && 64-y == 13) || (96-x == 43 && 64-y == 13) || (96-x == 40 && 64-y == 14) || (96-x == 43 && 64-y == 14) || (96-x == 46 && 64-y == 10) || (96-x == 47 && 64-y == 10) || (96-x == 48 && 64-y == 10) || (96-x == 49 && 64-y == 10) || (96-x == 46 && 64-y == 11) || (96-x == 46 && 64-y == 12) || (96-x == 47 && 64-y == 12) || (96-x == 48 && 64-y == 12) || (96-x == 49 && 64-y == 12) || (96-x == 49 && 64-y == 13) || (96-x == 46 && 64-y == 14) || (96-x == 47 && 64-y == 14) || (96-x == 48 && 64-y == 14) || (96-x == 49 && 64-y == 14) || (96-x == 51 && 64-y == 10) || (96-x == 55 && 64-y == 10) || (96-x == 51 && 64-y == 11) || (96-x == 55 && 64-y == 11) || (96-x == 51 && 64-y == 12) || (96-x == 55 && 64-y == 12) || (96-x == 51 && 64-y == 13) || (96-x == 53 && 64-y == 13) || (96-x == 55 && 64-y == 13) || (96-x == 52 && 64-y == 14) || (96-x == 54 && 64-y == 14) || (96-x == 57 && 64-y == 10) || (96-x == 57 && 64-y == 11) || (96-x == 57 && 64-y == 12) || (96-x == 57 && 64-y == 13) || (96-x == 57 && 64-y == 14) || (96-x == 59 && 64-y == 10) || (96-x == 60 && 64-y == 10) || (96-x == 61 && 64-y == 10) || (96-x == 60 && 64-y == 11) || (96-x == 60 && 64-y == 12) || (96-x == 60 && 64-y == 13) || (96-x == 60 && 64-y == 14) || (96-x == 64 && 64-y == 10) || (96-x == 65 && 64-y == 10) || (96-x == 63 && 64-y == 11) || (96-x == 66 && 64-y == 11) || (96-x == 63 && 64-y == 12) || (96-x == 63 && 64-y == 13) || (96-x == 66 && 64-y == 13) || (96-x == 64 && 64-y == 14) || (96-x == 65 && 64-y == 14) || (96-x == 68 && 64-y == 10) || (96-x == 71 && 64-y == 10) || (96-x == 68 && 64-y == 11) || (96-x == 71 && 64-y == 11) || (96-x == 68 && 64-y == 12) || (96-x == 69 && 64-y == 12) || (96-x == 70 && 64-y == 12) || (96-x == 71 && 64-y == 12) || (96-x == 68 && 64-y == 13) || (96-x == 71 && 64-y == 13) || (96-x == 68 && 64-y == 14) || (96-x == 71 && 64-y == 14) || (96-x == 75 && 64-y == 10) || (96-x == 74 && 64-y == 11) || (96-x == 75 && 64-y == 11) || (96-x == 75 && 64-y == 12) || (96-x == 75 && 64-y == 13) || (96-x == 74 && 64-y == 14) || (96-x == 75 && 64-y == 14) || (96-x == 76 && 64-y == 14) || (96-x == 78 && 64-y == 10) || (96-x == 79 && 64-y == 10) || (96-x == 80 && 64-y == 10) || (96-x == 80 && 64-y == 11) || (96-x == 78 && 64-y == 12) || (96-x == 79 && 64-y == 12) || (96-x == 80 && 64-y == 12) || (96-x == 80 && 64-y == 13) || (96-x == 78 && 64-y == 14) || (96-x == 79 && 64-y == 14) || (96-x == 80 && 64-y == 14))) begin
                            yoled_data <= WHITE;
                        
                        end
                        else  yoled_data <= ~WHITE;
                       
         
         end
         
         
         
         
         if (sw[13]) begin
        
         if (gamestate == 0) //menu display 
         begin
         
          // lines below are to show the cursor and move the cursor on input
         if (x > scaled_x_pos-1 && x < scaled_x_pos+2 && y > scaled_y_pos-1 && y < scaled_y_pos+2 ) 
                                           yoled_data <= (remembercolor) ? GREEN : WHITE;
         
             //write out "MAZE RUNNER"
            else if (((96-x == 23 && 64-y == 8) || (96-x == 27 && 64-y == 8) || (96-x == 23 && 64-y == 9) || (96-x == 24 && 64-y == 9) || (96-x == 26 && 64-y == 9) || (96-x == 27 && 64-y == 9) || (96-x == 23 && 64-y == 10) || (96-x == 25 && 64-y == 10) || (96-x == 27 && 64-y == 10) || (96-x == 23 && 64-y == 11) || (96-x == 27 && 64-y == 11) || (96-x == 23 && 64-y == 12) || (96-x == 27 && 64-y == 12) || (96-x == 30 && 64-y == 8) || (96-x == 31 && 64-y == 8) || (96-x == 29 && 64-y == 9) || (96-x == 32 && 64-y == 9) || (96-x == 29 && 64-y == 10) || (96-x == 30 && 64-y == 10) || (96-x == 31 && 64-y == 10) || (96-x == 32 && 64-y == 10) || (96-x == 29 && 64-y == 11) || (96-x == 32 && 64-y == 11) || (96-x == 29 && 64-y == 12) || (96-x == 32 && 64-y == 12) || (96-x == 34 && 64-y == 8) || (96-x == 35 && 64-y == 8) || (96-x == 36 && 64-y == 8) || (96-x == 36 && 64-y == 9) || (96-x == 35 && 64-y == 10) || (96-x == 34 && 64-y == 11) || (96-x == 34 && 64-y == 12) || (96-x == 35 && 64-y == 12) || (96-x == 36 && 64-y == 12) || (96-x == 38 && 64-y == 8) || (96-x == 39 && 64-y == 8) || (96-x == 40 && 64-y == 8) || (96-x == 41 && 64-y == 8) || (96-x == 38 && 64-y == 9) || (96-x == 38 && 64-y == 10) || (96-x == 39 && 64-y == 10) || (96-x == 40 && 64-y == 10) || (96-x == 41 && 64-y == 10) || (96-x == 38 && 64-y == 11) || (96-x == 38 && 64-y == 12) || (96-x == 39 && 64-y == 12) || (96-x == 40 && 64-y == 12) || (96-x == 41 && 64-y == 12) || (96-x == 44 && 64-y == 8) || (96-x == 45 && 64-y == 8) || (96-x == 46 && 64-y == 8) || (96-x == 44 && 64-y == 9) || (96-x == 47 && 64-y == 9) || (96-x == 44 && 64-y == 10) || (96-x == 45 && 64-y == 10) || (96-x == 46 && 64-y == 10) || (96-x == 44 && 64-y == 11) || (96-x == 46 && 64-y == 11) || (96-x == 44 && 64-y == 12) || (96-x == 47 && 64-y == 12) || (96-x == 49 && 64-y == 8) || (96-x == 52 && 64-y == 8) || (96-x == 49 && 64-y == 9) || (96-x == 52 && 64-y == 9) || (96-x == 49 && 64-y == 10) || (96-x == 52 && 64-y == 10) || (96-x == 49 && 64-y == 11) || (96-x == 52 && 64-y == 11) || (96-x == 50 && 64-y == 12) || (96-x == 51 && 64-y == 12) || (96-x == 54 && 64-y == 8) || (96-x == 57 && 64-y == 8) || (96-x == 54 && 64-y == 9) || (96-x == 55 && 64-y == 9) || (96-x == 57 && 64-y == 9) || (96-x == 54 && 64-y == 10) || (96-x == 56 && 64-y == 10) || (96-x == 57 && 64-y == 10) || (96-x == 54 && 64-y == 11) || (96-x == 57 && 64-y == 11) || (96-x == 54 && 64-y == 12) || (96-x == 57 && 64-y == 12) || (96-x == 59 && 64-y == 8) || (96-x == 62 && 64-y == 8) || (96-x == 59 && 64-y == 9) || (96-x == 60 && 64-y == 9) || (96-x == 62 && 64-y == 9) || (96-x == 59 && 64-y == 10) || (96-x == 61 && 64-y == 10) || (96-x == 62 && 64-y == 10) || (96-x == 59 && 64-y == 11) || (96-x == 62 && 64-y == 11) || (96-x == 59 && 64-y == 12) || (96-x == 62 && 64-y == 12) || (96-x == 64 && 64-y == 8) || (96-x == 65 && 64-y == 8) || (96-x == 66 && 64-y == 8) || (96-x == 67 && 64-y == 8) || (96-x == 64 && 64-y == 9) || (96-x == 64 && 64-y == 10) || (96-x == 65 && 64-y == 10) || (96-x == 66 && 64-y == 10) || (96-x == 67 && 64-y == 10) || (96-x == 64 && 64-y == 11) || (96-x == 64 && 64-y == 12) || (96-x == 65 && 64-y == 12) || (96-x == 66 && 64-y == 12) || (96-x == 67 && 64-y == 12) || (96-x == 69 && 64-y == 8) || (96-x == 70 && 64-y == 8) || (96-x == 71 && 64-y == 8) || (96-x == 69 && 64-y == 9) || (96-x == 72 && 64-y == 9) || (96-x == 69 && 64-y == 10) || (96-x == 70 && 64-y == 10) || (96-x == 71 && 64-y == 10) || (96-x == 69 && 64-y == 11) || (96-x == 71 && 64-y == 11) || (96-x == 69 && 64-y == 12) || (96-x == 72 && 64-y == 12))) begin
                yoled_data <= WHITE;
            end
            
            // 1
            else if (((96-x == 24 && 64-y == 27) || (96-x == 23 && 64-y == 28) || (96-x == 24 && 64-y == 28) || (96-x == 24 && 64-y == 29) || (96-x == 24 && 64-y == 30) || (96-x == 23 && 64-y == 31) || (96-x == 24 && 64-y == 31) || (96-x == 25 && 64-y == 31))) begin
                yoled_data <= BLACK;
            end
            
            // 3
            else if (((96-x == 23 && 64-y == 52) || (96-x == 24 && 64-y == 52) || (96-x == 25 && 64-y == 52) || (96-x == 25 && 64-y == 53) || (96-x == 23 && 64-y == 54) || (96-x == 24 && 64-y == 54) || (96-x == 25 && 64-y == 54) || (96-x == 25 && 64-y == 55) || (96-x == 23 && 64-y == 56) || (96-x == 24 && 64-y == 56) || (96-x == 25 && 64-y == 56))) begin
                yoled_data <= BLACK;
            end
            
            // 2
            else if (((96-x == 71 && 64-y == 27) || (96-x == 72 && 64-y == 27) || (96-x == 73 && 64-y == 27) || (96-x == 73 && 64-y == 28) || (96-x == 71 && 64-y == 29) || (96-x == 72 && 64-y == 29) || (96-x == 73 && 64-y == 29) || (96-x == 71 && 64-y == 30) || (96-x == 71 && 64-y == 31) || (96-x == 72 && 64-y == 31) || (96-x == 73 && 64-y == 31))) begin
                yoled_data <= BLACK;
            end
            
            //c
            
            else if (((96-x == 73 && 64-y == 52) || (96-x == 74 && 64-y == 52) || (96-x == 72 && 64-y == 53) || (96-x == 75 && 64-y == 53) || (96-x == 72 && 64-y == 54) || (96-x == 72 && 64-y == 55) || (96-x == 75 && 64-y == 55) || (96-x == 73 && 64-y == 56) || (96-x == 74 && 64-y == 56))) begin                yoled_data <= BLACK;
                yoled_data <= BLACK;
            end
            
            
            else if ( x>60 && x <84 && y > 27 && y < 47) yoled_data <= YELLOW ; //easy box
            else if ( x > 12 && x < 36 && y > 27 && y < 47) yoled_data <= ORANGE; // med box
            else if ( x>60 && x <84 && y > 2 && y < 22) yoled_data <= RED ;  // hard box
            else if ( x > 12 && x < 36 && y > 2 && y < 22) yoled_data <= BLUE; //cust box
            else 
            yoled_data <=  BLACK;
           
            
            if (84 > scaled_x_pos-1 && 60 < scaled_x_pos+2 && 47 > scaled_y_pos-1 && 27 < scaled_y_pos+2 &&righttrigger ) // mouse click easy box
                                               gamestate <= 1;
                                               
             else if (36 > scaled_x_pos-1 && 12 < scaled_x_pos+2 && 47 > scaled_y_pos-1 && 27 < scaled_y_pos+2 &&righttrigger ) // mouse click med box
                                                           gamestate <= 2;
                                                           
             else if (84 > scaled_x_pos-1 && 60 < scaled_x_pos+2 && 22 > scaled_y_pos-1 && 2 < scaled_y_pos+2 &&righttrigger) // mouse click hard box
                                                           gamestate <= 3;
                                               
            else if (36 > scaled_x_pos-1 && 12 < scaled_x_pos+2 && 22 > scaled_y_pos-1 && 2 < scaled_y_pos+2 &&righttrigger) // mouse click cust box
                                                           gamestate <= 4;   
            else gamestate <= 0;
            
            
            
            
            
             // mouse over easy box
            if (84 > scaled_x_pos-1 && 60 < scaled_x_pos+2 && 47 > scaled_y_pos-1 && 27 < scaled_y_pos+2) begin
             choice<=  1 ;
             showdisplay <= 1;
             end
            
            else if (36 > scaled_x_pos-1 && 12 < scaled_x_pos+2 && 47 > scaled_y_pos-1 && 27 < scaled_y_pos+2) begin
            choice <=  2; // mouse over med box
            showdisplay <= 1;
             end          
              
                        
            else if (84 > scaled_x_pos-1 && 60 < scaled_x_pos+2 && 22 > scaled_y_pos-1 && 2 < scaled_y_pos+2) begin
             choice <=3; // mouse over hard box
             showdisplay <=1;
             end
                        
            
             else if (36 > scaled_x_pos-1 && 12 < scaled_x_pos+2 && 22 > scaled_y_pos-1 && 2 < scaled_y_pos+2)begin
             choice <= 4 ; // mouse over cust box
             showdisplay<=1;
             end
           
                      
            else begin
                showdisplay<= 0;
                choice <= 0;
            end
     end
         
         
         ///////////////       assign the colors and led for different game state //////////////////////////////////////////
         
         
        if (gamestate == 1)begin  //easy mode
         
                    showdisplay <= 0; 
                      
                     if (x > movingx-1 &&  x < movingx +2 && y > scaled_y_pos-1 && y < scaled_y_pos+2) begin
                                                   yoled_data <= (remembercolor) ? GREEN : WHITE;
                     end
                     else if ( x <= 95 && x >70) yoled_data <= BLUE ; 
                     else if ( x >= 0 && x < 10) yoled_data <= GREEN; 
                     else if ( x >= 47 && x <= 49 && y >=52 && y <= 65) yoled_data <= WHITE ;  
                     
                     else if ( x >=  48 && x <= 70 && y >=51 && y <= 53) yoled_data <= WHITE ;  
                     else if ( x >= 58 && x <= 60 && y >=39 && y <= 52) yoled_data <= WHITE ;  
                     else if ( x >= 35 && x <= 37 && y >=39 && y <= 65) yoled_data <= WHITE ;  
                     else if ( x >= 10 && x <= 12 && y >=0 && y <= 52) yoled_data <= WHITE ;  
                     else if ( x >= 48 && x <= 70 && y >=25 && y <= 27) yoled_data <= WHITE ;  
                     else if ( x >= 48 && x <= 70 && y >=12 && y <= 14) yoled_data <= WHITE ;  
                     else if ( x >= 58 && x <= 60 && y >=0 && y <= 13) yoled_data <= WHITE ;  
                     else if ( x >= 23 && x <= 36 && y >=25 && y <= 27) yoled_data <= WHITE ;  
                     else if ( x >= 23 && x <= 36 && y >=12 && y <= 14) yoled_data <= WHITE ;  
                     else if ( x >= 35 && x <= 37 && y >=13 && y <= 26) yoled_data <= WHITE ;  
                     else if ( x >= 22 && x <= 24 && y >=26 && y <= 39) yoled_data <= WHITE ;  
                     else yoled_data <=  BLACK; 
                     
                     
                     starteasyclock <= 1; 
                     
                     if ( movingx >= 0 && movingx < 10) begin
                     starteasyclock <= 0;
                     gamestate <= 5; // win game
                     end
                     
                     
                  else if (( movingx >= 47 && movingx <= 49 && scaled_y_pos >=52 && scaled_y_pos <= 65)   
                  || ( movingx >=  48 && movingx <= 70 && scaled_y_pos >=51 && scaled_y_pos <= 53) 
                  || ( movingx >= 58 && movingx <= 60 && scaled_y_pos >=39 && scaled_y_pos <= 52)   
                  || ( movingx >= 35 && movingx <= 37 && scaled_y_pos >=39 && scaled_y_pos <= 65)   
                  || ( movingx >= 10 && movingx <= 12 && scaled_y_pos >=0 && scaled_y_pos <= 52)  
                  || ( movingx >= 48 && movingx <= 70 && scaled_y_pos >=25 && scaled_y_pos <= 27)    
                  || ( movingx >= 48 && movingx <= 70 && scaled_y_pos >=12 && scaled_y_pos <= 14)  
                  || ( movingx >= 58 && movingx <= 60 && scaled_y_pos >=0 && scaled_y_pos <= 13) 
                  || ( movingx >= 23 && movingx <= 36 && scaled_y_pos >=25 && scaled_y_pos <= 27) 
                   || ( movingx >= 23 && movingx <= 36 && scaled_y_pos >=12 && scaled_y_pos <= 14) 
                  || ( movingx >= 35 && movingx <= 37 && scaled_y_pos >=13 && scaled_y_pos <= 26) 
                  || ( movingx >= 22 && movingx <= 24 && scaled_y_pos >=26 && scaled_y_pos <= 39))
                   begin 
                            starteasyclock <= 0;
                            gamestate <= 6;
                     end
                               
         
         
         end
         
         
         else if (gamestate == 2)begin  //medium diff
                  
                             showdisplay <= 0; 
                  
                              if (x > mmovingx-1 &&  x < mmovingx +2 && y > scaled_y_pos-1 && y < scaled_y_pos+2) begin
                                                            yoled_data <= (remembercolor) ? GREEN : WHITE;
                              end
                              else if ( x <= 95 && x >70) yoled_data <= BLUE ; 
                              else if ( x >= 0 && x < 10) yoled_data <= GREEN; 
                              else if ( x >= 47 && x <= 49 && y >=0 && y <= 34) yoled_data <= WHITE ;  
                              else if ( x >= 47 && x <= 49 && y >=52 && y <= 65) yoled_data <= WHITE ;  
                              else if ( x >=  48 && x <= 70 && y >=51 && y <= 53) yoled_data <= WHITE ;  
                              else if ( x >= 61 && x <= 63 && y >=39 && y <= 52) yoled_data <= WHITE ;  
                              else if ( x >= 54 && x <= 56 && y >=26 && y <= 39) yoled_data <= WHITE ;  
                              else if ( x >= 55 && x <= 70 && y >=25 && y <= 27) yoled_data <= WHITE ;  
                              else if ( x >= 48 && x <= 70 && y >=25 && y <= 27) yoled_data <= WHITE ;  
                              else if ( x >= 47 && x <= 49 && y >=13 && y <= 42) yoled_data <= WHITE ;  
                              else if ( x >= 34 && x <= 36 && y >=39 && y <= 65) yoled_data <= WHITE ;  
                              else if ( x >= 21 && x <= 23 && y >=30 && y <= 52) yoled_data <= WHITE ;  
                              else if ( x >= 15 && x <= 17 && y >=0 && y <= 39) yoled_data <= WHITE ;  
                               
                              else yoled_data <= BLACK; 
                              
                              
                              startmedclock <= 1; 
                              if ( mmovingx >= 0 && mmovingx < 10) begin
                                  startmedclock <= 0; 
                                  gamestate <= 5; // win game
                              end
                             else if (( mmovingx >= 47 && mmovingx <= 49 && scaled_y_pos >=52 && scaled_y_pos <= 65)   
                             || ( mmovingx >= 47 && mmovingx <= 49 && scaled_y_pos >=0 && scaled_y_pos <= 34)  
                            || ( mmovingx >=  48 && mmovingx <= 70 && scaled_y_pos >=51 && scaled_y_pos <= 53)  
                           || ( mmovingx >= 61 && mmovingx <= 63 && scaled_y_pos >=39 && scaled_y_pos <= 52)    
                            || ( mmovingx >= 54 && mmovingx <= 56 && scaled_y_pos >=26 && scaled_y_pos <= 39)      
                            || ( mmovingx >= 55 && mmovingx <= 70 && scaled_y_pos >=25 && scaled_y_pos <= 27)  
                            || ( mmovingx >= 48 && mmovingx <= 70 && scaled_y_pos >=25 && scaled_y_pos <= 27)   
                            || ( mmovingx >= 47 && mmovingx <= 49 && scaled_y_pos >=13 && scaled_y_pos <= 42)      
                           || ( mmovingx >= 34 && mmovingx <= 36 && scaled_y_pos >=39 && scaled_y_pos <= 65)      
                            || ( mmovingx >= 21 && mmovingx <= 23 && scaled_y_pos >=30 && scaled_y_pos <= 52)     
                            || ( mmovingx >= 15 && mmovingx <= 17 && scaled_y_pos >=0 && scaled_y_pos <= 39)) 
                            begin
                                startmedclock <= 0;
                                gamestate <= 6;    
                            end
                                                             
         
                  
                  end
                  
                  
                  else if (gamestate == 3)begin  //hard diff
                           
                                      showdisplay <= 0; 
                           
                                       if (x > hmovingx-1 &&  x < hmovingx +2 && y > scaled_y_pos-1 && y < scaled_y_pos+2) begin
                                                                     yoled_data <= (remembercolor) ? GREEN : WHITE;
                                       end
                                       else if ( x<95 && x >70) yoled_data <= BLUE ; 
                                       else if ( x >= 0 && x < 10) yoled_data <= GREEN; 
                                       else if ( x >= 59 && x <= 61 && y >=32 && y <= 65) yoled_data <= WHITE ; 
                                       else if ( x >= 47 && x <= 49 && y >=0 && y <= 34) yoled_data <= WHITE ;   
                                       else if ( x >=  49 && x <= 51 && y >=16 && y <= 48) yoled_data <= WHITE ;  
                                       else if ( x >= 39 && x <= 41 && y >=0 && y <= 16) yoled_data <= WHITE ;  
                                       else if ( x >= 39 && x <= 41 && y >=32 && y <= 65) yoled_data <= WHITE ;  
                                       else if ( x >= 29 && x <= 31 && y >=16 && y <= 40) yoled_data <= WHITE ;  
                                       else if ( x >= 19 && x <= 21 && y >=40 && y <= 65) yoled_data <= WHITE ;  
                                       else if ( x >= 10 && x <= 12 && y >=16 && y <= 48) yoled_data <= WHITE ;  
                                       
                                       else yoled_data <= BLACK; 
                                       
                                       
                                       starthardclock = 1; 
                                       if ( hmovingx >= 0 && hmovingx < 10)begin
                                            starthardclock <= 0;
                                            gamestate <= 5; // win game
                                        end
                                      else if (( hmovingx >= 59 && hmovingx <= 61 && scaled_y_pos >=32 && scaled_y_pos <= 65)  
                                      || ( hmovingx >= 47 && hmovingx <= 49 && scaled_y_pos >=0 && scaled_y_pos <= 34)  
                                      || ( hmovingx >=  49 && hmovingx <= 51 && scaled_y_pos >=16 && scaled_y_pos <= 48)  
                                     || ( hmovingx >= 39 && hmovingx <= 41 && scaled_y_pos >=0 && scaled_y_pos <= 16)   
                                      || ( hmovingx >= 39 && hmovingx <= 41 && scaled_y_pos >=32 && scaled_y_pos <= 65) 
                                      || ( hmovingx >= 29 && hmovingx <= 31 && scaled_y_pos >=16 && scaled_y_pos <= 40)  
                                      || ( hmovingx >= 19 && hmovingx <= 21 && scaled_y_pos >=40 && scaled_y_pos <= 65) 
                                      || ( hmovingx >= 10 && hmovingx <= 12 && scaled_y_pos >=16 && scaled_y_pos <= 48))
                                       begin
                                          starthardclock <= 0;
                                          gamestate <= 6;
                                      end
                                       
                                                 
                           
                           
                           end
         
         //draw and erase function
         
         else if (gamestate == 4) begin  //drawing the map stage
         // lines below are to show the cursor and move the cursor on input
         
        
                    showdisplay <= 0; 
         
                    // lines below are to show the cursor and move the cursor on input
                      if (x > scaled_x_pos-1 && x < scaled_x_pos+2 && y > scaled_y_pos-1 && y < scaled_y_pos+2) begin
                                           yoled_data <= (remembercolor) ? GREEN : WHITE;
                      end
                      else if ( x<95 && x >70) yoled_data <= BLUE ; 
                      else if ( x >= 0 && x < 10) yoled_data <= GREEN; 
                      else if (memory[pixel_index] == 1)
                        yoled_data <= customcolor;
                       else 
                        yoled_data <=  BLACK;
                        
                        
                     if (righttrigger)  begin
                            if (scaled_x_pos > 10 && scaled_x_pos < 70) begin
                                 memory[96*(scaled_y_pos-1)+scaled_x_pos] <= (sw[14])? 0 : 1;
                            end  
                     end
                         
                         
                         if (btnR) begin
                            gamestate <= 7;
                         end
                         
                         
         end
         
         else if (gamestate == 5) begin  // win game
                     if ( x>=28 && x <=32 && y >= 10 && y <= 20) yoled_data <= GREEN ; 
                     else if ( x>=62 && x <=67 && y >= 10 && y <= 20) yoled_data <= GREEN ;  // med box
                     else if ( x>=38 && x <=42 && y >= 30 && y <= 40) yoled_data <= GREEN ;   // hard box
                     else if ( x>=52 && x <=57 && y >= 30 && y <= 40) yoled_data <= GREEN ; 
                     else if ( x>=33 && x <=62 && y >= 10 && y <= 13) yoled_data <= GREEN ;   // hard box
                     else if (((96-x == 32 && 64-y == 10) || (96-x == 33 && 64-y == 10) || (96-x == 34 && 64-y == 10) || (96-x == 31 && 64-y == 11) || (96-x == 31 && 64-y == 12) || (96-x == 33 && 64-y == 12) || (96-x == 34 && 64-y == 12) || (96-x == 35 && 64-y == 12) || (96-x == 31 && 64-y == 13) || (96-x == 35 && 64-y == 13) || (96-x == 32 && 64-y == 14) || (96-x == 33 && 64-y == 14) || (96-x == 34 && 64-y == 14) || (96-x == 38 && 64-y == 10) || (96-x == 39 && 64-y == 10) || (96-x == 37 && 64-y == 11) || (96-x == 40 && 64-y == 11) || (96-x == 37 && 64-y == 12) || (96-x == 40 && 64-y == 12) || (96-x == 37 && 64-y == 13) || (96-x == 40 && 64-y == 13) || (96-x == 38 && 64-y == 14) || (96-x == 39 && 64-y == 14) || (96-x == 43 && 64-y == 10) || (96-x == 44 && 64-y == 10) || (96-x == 42 && 64-y == 11) || (96-x == 45 && 64-y == 11) || (96-x == 42 && 64-y == 12) || (96-x == 45 && 64-y == 12) || (96-x == 42 && 64-y == 13) || (96-x == 45 && 64-y == 13) || (96-x == 43 && 64-y == 14) || (96-x == 44 && 64-y == 14) || (96-x == 47 && 64-y == 10) || (96-x == 48 && 64-y == 10) || (96-x == 49 && 64-y == 10) || (96-x == 47 && 64-y == 11) || (96-x == 50 && 64-y == 11) || (96-x == 47 && 64-y == 12) || (96-x == 50 && 64-y == 12) || (96-x == 47 && 64-y == 13) || (96-x == 50 && 64-y == 13) || (96-x == 47 && 64-y == 14) || (96-x == 48 && 64-y == 14) || (96-x == 49 && 64-y == 14) || (96-x == 53 && 64-y == 10) || (96-x == 54 && 64-y == 10) || (96-x == 55 && 64-y == 10) || (96-x == 55 && 64-y == 11) || (96-x == 55 && 64-y == 12) || (96-x == 53 && 64-y == 13) || (96-x == 55 && 64-y == 13) || (96-x == 54 && 64-y == 14) || (96-x == 58 && 64-y == 10) || (96-x == 59 && 64-y == 10) || (96-x == 57 && 64-y == 11) || (96-x == 60 && 64-y == 11) || (96-x == 57 && 64-y == 12) || (96-x == 60 && 64-y == 12) || (96-x == 57 && 64-y == 13) || (96-x == 60 && 64-y == 13) || (96-x == 58 && 64-y == 14) || (96-x == 59 && 64-y == 14) || (96-x == 62 && 64-y == 10) || (96-x == 63 && 64-y == 10) || (96-x == 64 && 64-y == 10) || (96-x == 62 && 64-y == 11) || (96-x == 65 && 64-y == 11) || (96-x == 62 && 64-y == 12) || (96-x == 63 && 64-y == 12) || (96-x == 64 && 64-y == 12) || (96-x == 62 && 64-y == 13) || (96-x == 65 && 64-y == 13) || (96-x == 62 && 64-y == 14) || (96-x == 63 && 64-y == 14) || (96-x == 64 && 64-y == 14))) begin
                        yoled_data <= WHITE;
                     end
                     else 
                     yoled_data <=  partycolor;
                     
  //2nd player part ////////////////////
           
           
                               
                             if (sw[14])begin
                               
                                            if (pixel_index2 == (96*(scaled_y_pos2-1)+cmovingx) && memory[pixel_index2] == 1 )
                                                                        begin
                                                                            startcustclock <= 0;
                                                                            gamestate2 <= 6; 
                                                                        end
                                                else if (x > cmovingx-1 &&  x < cmovingx +2 && y > scaled_y_pos2-1 && y < scaled_y_pos2+2) begin
                                                                       yoled_data2 <= (remembercolor) ? GREEN : WHITE;
                                                                     end
                                                 else if ( x<95 && x >70) yoled_data2 <= BLUE ; 
                                                 else if ( x >= 0 && x < 10) yoled_data2 <= GREEN; 
                                                 else if (memory[pixel_index2] == 1) 
                                                           yoled_data2 <= customcolor;
                                                 
                                                 else yoled_data2 <=  BLACK; 
                                                  
                                                 startcustclock <= 1; 
                                                 if ( cmovingx >= 0 && cmovingx < 10) begin
                                                 startcustclock <= 0;
                                                   gamestate2 <= 5; // win game
                                                   end
                    
                                         end
                               
                               if (sw[14] && gamestate2 == 5) begin //player 2 win game
                               
                               
                                                    if ( x2>=28 && x2 <=32 && y2 >= 10 && y2 <= 20) yoled_data2 <= GREEN ; 
                                                    else if ( x2>=62 && x2 <=67 && y2 >= 10 && y2 <= 20) yoled_data2 <= GREEN ;  // med box2
                                                    else if ( x2>=38 && x2 <=42 && y2 >= 30 && y2 <= 40) yoled_data2 <= GREEN ;   // hard box2
                                                    else if ( x2>=52 && x2 <=57 && y2 >= 30 && y2 <= 40) yoled_data2 <= GREEN ; 
                                                    else if ( x2>=33 && x2 <=62 && y2 >= 10 && y2 <= 13) yoled_data2 <= GREEN ;   // hard box2
                                                    else if (((96-x2 == 32 && 64-y2 == 10) || (96-x2 == 33 && 64-y2 == 10) || (96-x2 == 34 && 64-y2 == 10) || (96-x2 == 31 && 64-y2 == 11) || (96-x2 == 31 && 64-y2 == 12) || (96-x2 == 33 && 64-y2 == 12) || (96-x2 == 34 && 64-y2 == 12) || (96-x2 == 35 && 64-y2 == 12) || (96-x2 == 31 && 64-y2 == 13) || (96-x2 == 35 && 64-y2 == 13) || (96-x2 == 32 && 64-y2 == 14) || (96-x2 == 33 && 64-y2 == 14) || (96-x2 == 34 && 64-y2 == 14) || (96-x2 == 38 && 64-y2 == 10) || (96-x2 == 39 && 64-y2 == 10) || (96-x2 == 37 && 64-y2 == 11) || (96-x2 == 40 && 64-y2 == 11) || (96-x2 == 37 && 64-y2 == 12) || (96-x2 == 40 && 64-y2 == 12) || (96-x2 == 37 && 64-y2 == 13) || (96-x2 == 40 && 64-y2 == 13) || (96-x2 == 38 && 64-y2 == 14) || (96-x2 == 39 && 64-y2 == 14) || (96-x2 == 43 && 64-y2 == 10) || (96-x2 == 44 && 64-y2 == 10) || (96-x2 == 42 && 64-y2 == 11) || (96-x2 == 45 && 64-y2 == 11) || (96-x2 == 42 && 64-y2 == 12) || (96-x2 == 45 && 64-y2 == 12) || (96-x2 == 42 && 64-y2 == 13) || (96-x2 == 45 && 64-y2 == 13) || (96-x2 == 43 && 64-y2 == 14) || (96-x2 == 44 && 64-y2 == 14) || (96-x2 == 47 && 64-y2 == 10) || (96-x2 == 48 && 64-y2 == 10) || (96-x2 == 49 && 64-y2 == 10) || (96-x2 == 47 && 64-y2 == 11) || (96-x2 == 50 && 64-y2 == 11) || (96-x2 == 47 && 64-y2 == 12) || (96-x2 == 50 && 64-y2 == 12) || (96-x2 == 47 && 64-y2 == 13) || (96-x2 == 50 && 64-y2 == 13) || (96-x2 == 47 && 64-y2 == 14) || (96-x2 == 48 && 64-y2 == 14) || (96-x2 == 49 && 64-y2 == 14) || (96-x2 == 53 && 64-y2 == 10) || (96-x2 == 54 && 64-y2 == 10) || (96-x2 == 55 && 64-y2 == 10) || (96-x2 == 55 && 64-y2 == 11) || (96-x2 == 55 && 64-y2 == 12) || (96-x2 == 53 && 64-y2 == 13) || (96-x2 == 55 && 64-y2 == 13) || (96-x2 == 54 && 64-y2 == 14) || (96-x2 == 58 && 64-y2 == 10) || (96-x2 == 59 && 64-y2 == 10) || (96-x2 == 57 && 64-y2 == 11) || (96-x2 == 60 && 64-y2 == 11) || (96-x2 == 57 && 64-y2 == 12) || (96-x2 == 60 && 64-y2 == 12) || (96-x2 == 57 && 64-y2 == 13) || (96-x2 == 60 && 64-y2 == 13) || (96-x2 == 58 && 64-y2 == 14) || (96-x2 == 59 && 64-y2 == 14) || (96-x2 == 62 && 64-y2 == 10) || (96-x2 == 63 && 64-y2 == 10) || (96-x2 == 64 && 64-y2 == 10) || (96-x2 == 62 && 64-y2 == 11) || (96-x2 == 65 && 64-y2 == 11) || (96-x2 == 62 && 64-y2 == 12) || (96-x2 == 63 && 64-y2 == 12) || (96-x2 == 64 && 64-y2 == 12) || (96-x2 == 62 && 64-y2 == 13) || (96-x2 == 65 && 64-y2 == 13) || (96-x2 == 62 && 64-y2 == 14) || (96-x2 == 63 && 64-y2 == 14) || (96-x2 == 64 && 64-y2 == 14))) begin
                                                       yoled_data2 <= WHITE;
                                                    end
                                                    else 
                                                    yoled_data2 <=  partycolor ;
                               
                                    end
                          
                         
                    
                         
                         
                                if (sw[14] && gamestate2 == 6) begin
                         
                                              if ( x2>=28 && x2 <=32 && y2 >= 0 && y2 <= 10) yoled_data2 <= RED ; //easy2 box2
                                              else if ( x2>=62 && x2 <=67 && y2 >= 0 && y2 <= 10) yoled_data2 <= RED ;  // med box2
                                              else if ( x2>=38 && x2 <=42 && y2 >= 20 && y2 <= 40) yoled_data2 <= RED ;   // hard box2
                                              else if ( x2>=52 && x2 <=57 && y2 >= 20 && y2 <= 40) yoled_data2 <= RED ; 
                                              else if ( x2>=33 && x2 <=62 && y2 >= 7 && y2 <= 10) yoled_data2 <= RED ;   // hard box2
                                              else if (((96-x2 == 28 && 64-y2 == 10) || (96-x2 == 29 && 64-y2 == 10) || (96-x2 == 30 && 64-y2 == 10) || (96-x2 == 27 && 64-y2 == 11) || (96-x2 == 27 && 64-y2 == 12) || (96-x2 == 29 && 64-y2 == 12) || (96-x2 == 30 && 64-y2 == 12) || (96-x2 == 31 && 64-y2 == 12) || (96-x2 == 27 && 64-y2 == 13) || (96-x2 == 31 && 64-y2 == 13) || (96-x2 == 28 && 64-y2 == 14) || (96-x2 == 29 && 64-y2 == 14) || (96-x2 == 30 && 64-y2 == 14) || (96-x2 == 34 && 64-y2 == 10) || (96-x2 == 35 && 64-y2 == 10) || (96-x2 == 33 && 64-y2 == 11) || (96-x2 == 36 && 64-y2 == 11) || (96-x2 == 33 && 64-y2 == 12) || (96-x2 == 34 && 64-y2 == 12) || (96-x2 == 35 && 64-y2 == 12) || (96-x2 == 36 && 64-y2 == 12) || (96-x2 == 33 && 64-y2 == 13) || (96-x2 == 36 && 64-y2 == 13) || (96-x2 == 33 && 64-y2 == 14) || (96-x2 == 36 && 64-y2 == 14) || (96-x2 == 38 && 64-y2 == 10) || (96-x2 == 42 && 64-y2 == 10) || (96-x2 == 38 && 64-y2 == 11) || (96-x2 == 39 && 64-y2 == 11) || (96-x2 == 41 && 64-y2 == 11) || (96-x2 == 42 && 64-y2 == 11) || (96-x2 == 38 && 64-y2 == 12) || (96-x2 == 40 && 64-y2 == 12) || (96-x2 == 42 && 64-y2 == 12) || (96-x2 == 38 && 64-y2 == 13) || (96-x2 == 42 && 64-y2 == 13) || (96-x2 == 38 && 64-y2 == 14) || (96-x2 == 42 && 64-y2 == 14) || (96-x2 == 44 && 64-y2 == 10) || (96-x2 == 45 && 64-y2 == 10) || (96-x2 == 46 && 64-y2 == 10) || (96-x2 == 47 && 64-y2 == 10) || (96-x2 == 44 && 64-y2 == 11) || (96-x2 == 44 && 64-y2 == 12) || (96-x2 == 45 && 64-y2 == 12) || (96-x2 == 46 && 64-y2 == 12) || (96-x2 == 47 && 64-y2 == 12) || (96-x2 == 44 && 64-y2 == 13) || (96-x2 == 44 && 64-y2 == 14) || (96-x2 == 45 && 64-y2 == 14) || (96-x2 == 46 && 64-y2 == 14) || (96-x2 == 47 && 64-y2 == 14) || (96-x2 == 51 && 64-y2 == 10) || (96-x2 == 52 && 64-y2 == 10) || (96-x2 == 50 && 64-y2 == 11) || (96-x2 == 53 && 64-y2 == 11) || (96-x2 == 50 && 64-y2 == 12) || (96-x2 == 53 && 64-y2 == 12) || (96-x2 == 50 && 64-y2 == 13) || (96-x2 == 53 && 64-y2 == 13) || (96-x2 == 51 && 64-y2 == 14) || (96-x2 == 52 && 64-y2 == 14) || (96-x2 == 55 && 64-y2 == 10) || (96-x2 == 59 && 64-y2 == 10) || (96-x2 == 55 && 64-y2 == 11) || (96-x2 == 59 && 64-y2 == 11) || (96-x2 == 55 && 64-y2 == 12) || (96-x2 == 59 && 64-y2 == 12) || (96-x2 == 56 && 64-y2 == 13) || (96-x2 == 58 && 64-y2 == 13) || (96-x2 == 57 && 64-y2 == 14) || (96-x2 == 61 && 64-y2 == 10) || (96-x2 == 62 && 64-y2 == 10) || (96-x2 == 63 && 64-y2 == 10) || (96-x2 == 64 && 64-y2 == 10) || (96-x2 == 61 && 64-y2 == 11) || (96-x2 == 61 && 64-y2 == 12) || (96-x2 == 62 && 64-y2 == 12) || (96-x2 == 63 && 64-y2 == 12) || (96-x2 == 64 && 64-y2 == 12) || (96-x2 == 61 && 64-y2 == 13) || (96-x2 == 61 && 64-y2 == 14) || (96-x2 == 62 && 64-y2 == 14) || (96-x2 == 63 && 64-y2 == 14) || (96-x2 == 64 && 64-y2 == 14) || (96-x2 == 66 && 64-y2 == 10) || (96-x2 == 67 && 64-y2 == 10) || (96-x2 == 68 && 64-y2 == 10) || (96-x2 == 66 && 64-y2 == 11) || (96-x2 == 69 && 64-y2 == 11) || (96-x2 == 66 && 64-y2 == 12) || (96-x2 == 67 && 64-y2 == 12) || (96-x2 == 68 && 64-y2 == 12) || (96-x2 == 66 && 64-y2 == 13) || (96-x2 == 68 && 64-y2 == 13) || (96-x2 == 66 && 64-y2 == 14) || (96-x2 == 69 && 64-y2 == 14))) begin
                                                yoled_data2 <= WHITE ;
                                              end
                                              else
                                              yoled_data2 <=  partycolor ;
                                 end            

         
                     
         end
         
         
         else if (gamestate == 6) begin // lose game 
         
                      if ( x>=28 && x <=32 && y >= 0 && y <= 10) yoled_data <= RED ; //easy box
                      else if ( x>=62 && x <=67 && y >= 0 && y <= 10) yoled_data <= RED ;  // med box
                      else if ( x>=38 && x <=42 && y >= 20 && y <= 40) yoled_data <= RED ;   // hard box
                      else if ( x>=52 && x <=57 && y >= 20 && y <= 40) yoled_data <= RED ; 
                      else if ( x>=33 && x <=62 && y >= 7 && y <= 10) yoled_data <= RED ;   // hard box
                      else if (((96-x == 28 && 64-y == 10) || (96-x == 29 && 64-y == 10) || (96-x == 30 && 64-y == 10) || (96-x == 27 && 64-y == 11) || (96-x == 27 && 64-y == 12) || (96-x == 29 && 64-y == 12) || (96-x == 30 && 64-y == 12) || (96-x == 31 && 64-y == 12) || (96-x == 27 && 64-y == 13) || (96-x == 31 && 64-y == 13) || (96-x == 28 && 64-y == 14) || (96-x == 29 && 64-y == 14) || (96-x == 30 && 64-y == 14) || (96-x == 34 && 64-y == 10) || (96-x == 35 && 64-y == 10) || (96-x == 33 && 64-y == 11) || (96-x == 36 && 64-y == 11) || (96-x == 33 && 64-y == 12) || (96-x == 34 && 64-y == 12) || (96-x == 35 && 64-y == 12) || (96-x == 36 && 64-y == 12) || (96-x == 33 && 64-y == 13) || (96-x == 36 && 64-y == 13) || (96-x == 33 && 64-y == 14) || (96-x == 36 && 64-y == 14) || (96-x == 38 && 64-y == 10) || (96-x == 42 && 64-y == 10) || (96-x == 38 && 64-y == 11) || (96-x == 39 && 64-y == 11) || (96-x == 41 && 64-y == 11) || (96-x == 42 && 64-y == 11) || (96-x == 38 && 64-y == 12) || (96-x == 40 && 64-y == 12) || (96-x == 42 && 64-y == 12) || (96-x == 38 && 64-y == 13) || (96-x == 42 && 64-y == 13) || (96-x == 38 && 64-y == 14) || (96-x == 42 && 64-y == 14) || (96-x == 44 && 64-y == 10) || (96-x == 45 && 64-y == 10) || (96-x == 46 && 64-y == 10) || (96-x == 47 && 64-y == 10) || (96-x == 44 && 64-y == 11) || (96-x == 44 && 64-y == 12) || (96-x == 45 && 64-y == 12) || (96-x == 46 && 64-y == 12) || (96-x == 47 && 64-y == 12) || (96-x == 44 && 64-y == 13) || (96-x == 44 && 64-y == 14) || (96-x == 45 && 64-y == 14) || (96-x == 46 && 64-y == 14) || (96-x == 47 && 64-y == 14) || (96-x == 51 && 64-y == 10) || (96-x == 52 && 64-y == 10) || (96-x == 50 && 64-y == 11) || (96-x == 53 && 64-y == 11) || (96-x == 50 && 64-y == 12) || (96-x == 53 && 64-y == 12) || (96-x == 50 && 64-y == 13) || (96-x == 53 && 64-y == 13) || (96-x == 51 && 64-y == 14) || (96-x == 52 && 64-y == 14) || (96-x == 55 && 64-y == 10) || (96-x == 59 && 64-y == 10) || (96-x == 55 && 64-y == 11) || (96-x == 59 && 64-y == 11) || (96-x == 55 && 64-y == 12) || (96-x == 59 && 64-y == 12) || (96-x == 56 && 64-y == 13) || (96-x == 58 && 64-y == 13) || (96-x == 57 && 64-y == 14) || (96-x == 61 && 64-y == 10) || (96-x == 62 && 64-y == 10) || (96-x == 63 && 64-y == 10) || (96-x == 64 && 64-y == 10) || (96-x == 61 && 64-y == 11) || (96-x == 61 && 64-y == 12) || (96-x == 62 && 64-y == 12) || (96-x == 63 && 64-y == 12) || (96-x == 64 && 64-y == 12) || (96-x == 61 && 64-y == 13) || (96-x == 61 && 64-y == 14) || (96-x == 62 && 64-y == 14) || (96-x == 63 && 64-y == 14) || (96-x == 64 && 64-y == 14) || (96-x == 66 && 64-y == 10) || (96-x == 67 && 64-y == 10) || (96-x == 68 && 64-y == 10) || (96-x == 66 && 64-y == 11) || (96-x == 69 && 64-y == 11) || (96-x == 66 && 64-y == 12) || (96-x == 67 && 64-y == 12) || (96-x == 68 && 64-y == 12) || (96-x == 66 && 64-y == 13) || (96-x == 68 && 64-y == 13) || (96-x == 66 && 64-y == 14) || (96-x == 69 && 64-y == 14))) begin
                        yoled_data <= WHITE ;
                      end
                      else
                      yoled_data <= partycolor ;
          
                      
                      
                       //2nd player part ////////////////////
                                                       
                                                       
                                                       
                                                     if (sw[14])begin
                                                       
                                                                    if (pixel_index2 == (96*(scaled_y_pos2-1)+cmovingx) && memory[pixel_index2] == 1 )
                                                                                                begin
                                                                                                    startcustclock <= 0;
                                                                                                    gamestate2 <= 6; 
                                                                                                end
                                                                        else if (x > cmovingx-1 &&  x < cmovingx +2 && y > scaled_y_pos2-1 && y < scaled_y_pos2+2) begin
                                                                                               yoled_data2 <= (remembercolor) ? GREEN : WHITE;
                                                                                             end
                                                                         else if ( x<95 && x >70) yoled_data2 <= BLUE ; 
                                                                         else if ( x >= 0 && x < 10) yoled_data2 <= GREEN; 
                                                                         else if (memory[pixel_index2] == 1) 
                                                                                   yoled_data2 <= customcolor;
                                                                         
                                                                         else yoled_data2 <=  BLACK; 
                                                                          
                                                                         startcustclock <= 1; 
                                                                         if ( cmovingx >= 0 && cmovingx < 10) begin
                                                                         startcustclock <= 0;
                                                                           gamestate2 <= 5; // win game
                                                                           end
                                           
                                                                 end
                                                       
                                                       if (sw[14] && gamestate2 == 5) begin //player 2 win game
                                                       
                                                       
                                                                            if ( x2>=28 && x2 <=32 && y2 >= 10 && y2 <= 20) yoled_data2 <= GREEN ; 
                                                                            else if ( x2>=62 && x2 <=67 && y2 >= 10 && y2 <= 20) yoled_data2 <= GREEN ;  // med box2
                                                                            else if ( x2>=38 && x2 <=42 && y2 >= 30 && y2 <= 40) yoled_data2 <= GREEN ;   // hard box2
                                                                            else if ( x2>=52 && x2 <=57 && y2 >= 30 && y2 <= 40) yoled_data2 <= GREEN ; 
                                                                            else if ( x2>=33 && x2 <=62 && y2 >= 10 && y2 <= 13) yoled_data2 <= GREEN ;   // hard box2
                                                                            else if (((96-x2 == 32 && 64-y2 == 10) || (96-x2 == 33 && 64-y2 == 10) || (96-x2 == 34 && 64-y2 == 10) || (96-x2 == 31 && 64-y2 == 11) || (96-x2 == 31 && 64-y2 == 12) || (96-x2 == 33 && 64-y2 == 12) || (96-x2 == 34 && 64-y2 == 12) || (96-x2 == 35 && 64-y2 == 12) || (96-x2 == 31 && 64-y2 == 13) || (96-x2 == 35 && 64-y2 == 13) || (96-x2 == 32 && 64-y2 == 14) || (96-x2 == 33 && 64-y2 == 14) || (96-x2 == 34 && 64-y2 == 14) || (96-x2 == 38 && 64-y2 == 10) || (96-x2 == 39 && 64-y2 == 10) || (96-x2 == 37 && 64-y2 == 11) || (96-x2 == 40 && 64-y2 == 11) || (96-x2 == 37 && 64-y2 == 12) || (96-x2 == 40 && 64-y2 == 12) || (96-x2 == 37 && 64-y2 == 13) || (96-x2 == 40 && 64-y2 == 13) || (96-x2 == 38 && 64-y2 == 14) || (96-x2 == 39 && 64-y2 == 14) || (96-x2 == 43 && 64-y2 == 10) || (96-x2 == 44 && 64-y2 == 10) || (96-x2 == 42 && 64-y2 == 11) || (96-x2 == 45 && 64-y2 == 11) || (96-x2 == 42 && 64-y2 == 12) || (96-x2 == 45 && 64-y2 == 12) || (96-x2 == 42 && 64-y2 == 13) || (96-x2 == 45 && 64-y2 == 13) || (96-x2 == 43 && 64-y2 == 14) || (96-x2 == 44 && 64-y2 == 14) || (96-x2 == 47 && 64-y2 == 10) || (96-x2 == 48 && 64-y2 == 10) || (96-x2 == 49 && 64-y2 == 10) || (96-x2 == 47 && 64-y2 == 11) || (96-x2 == 50 && 64-y2 == 11) || (96-x2 == 47 && 64-y2 == 12) || (96-x2 == 50 && 64-y2 == 12) || (96-x2 == 47 && 64-y2 == 13) || (96-x2 == 50 && 64-y2 == 13) || (96-x2 == 47 && 64-y2 == 14) || (96-x2 == 48 && 64-y2 == 14) || (96-x2 == 49 && 64-y2 == 14) || (96-x2 == 53 && 64-y2 == 10) || (96-x2 == 54 && 64-y2 == 10) || (96-x2 == 55 && 64-y2 == 10) || (96-x2 == 55 && 64-y2 == 11) || (96-x2 == 55 && 64-y2 == 12) || (96-x2 == 53 && 64-y2 == 13) || (96-x2 == 55 && 64-y2 == 13) || (96-x2 == 54 && 64-y2 == 14) || (96-x2 == 58 && 64-y2 == 10) || (96-x2 == 59 && 64-y2 == 10) || (96-x2 == 57 && 64-y2 == 11) || (96-x2 == 60 && 64-y2 == 11) || (96-x2 == 57 && 64-y2 == 12) || (96-x2 == 60 && 64-y2 == 12) || (96-x2 == 57 && 64-y2 == 13) || (96-x2 == 60 && 64-y2 == 13) || (96-x2 == 58 && 64-y2 == 14) || (96-x2 == 59 && 64-y2 == 14) || (96-x2 == 62 && 64-y2 == 10) || (96-x2 == 63 && 64-y2 == 10) || (96-x2 == 64 && 64-y2 == 10) || (96-x2 == 62 && 64-y2 == 11) || (96-x2 == 65 && 64-y2 == 11) || (96-x2 == 62 && 64-y2 == 12) || (96-x2 == 63 && 64-y2 == 12) || (96-x2 == 64 && 64-y2 == 12) || (96-x2 == 62 && 64-y2 == 13) || (96-x2 == 65 && 64-y2 == 13) || (96-x2 == 62 && 64-y2 == 14) || (96-x2 == 63 && 64-y2 == 14) || (96-x2 == 64 && 64-y2 == 14))) begin
                                                                               yoled_data2 <= WHITE;
                                                                            end
                                                                            else 
                                                                            yoled_data2 <=  partycolor ;
                                                       
                                                            end
                                                  
                                                 
                                         
                                                 
                                                 
                                                        if (sw[14] && gamestate2 == 6) begin
                                                 
                                                                      if ( x2>=28 && x2 <=32 && y2 >= 0 && y2 <= 10) yoled_data2 <= RED ; //easy2 box2
                                                                      else if ( x2>=62 && x2 <=67 && y2 >= 0 && y2 <= 10) yoled_data2 <= RED ;  // med box2
                                                                      else if ( x2>=38 && x2 <=42 && y2 >= 20 && y2 <= 40) yoled_data2 <= RED ;   // hard box2
                                                                      else if ( x2>=52 && x2 <=57 && y2 >= 20 && y2 <= 40) yoled_data2 <= RED ; 
                                                                      else if ( x2>=33 && x2 <=62 && y2 >= 7 && y2 <= 10) yoled_data2 <= RED ;   // hard box2
                                                                      else if (((96-x2 == 28 && 64-y2 == 10) || (96-x2 == 29 && 64-y2 == 10) || (96-x2 == 30 && 64-y2 == 10) || (96-x2 == 27 && 64-y2 == 11) || (96-x2 == 27 && 64-y2 == 12) || (96-x2 == 29 && 64-y2 == 12) || (96-x2 == 30 && 64-y2 == 12) || (96-x2 == 31 && 64-y2 == 12) || (96-x2 == 27 && 64-y2 == 13) || (96-x2 == 31 && 64-y2 == 13) || (96-x2 == 28 && 64-y2 == 14) || (96-x2 == 29 && 64-y2 == 14) || (96-x2 == 30 && 64-y2 == 14) || (96-x2 == 34 && 64-y2 == 10) || (96-x2 == 35 && 64-y2 == 10) || (96-x2 == 33 && 64-y2 == 11) || (96-x2 == 36 && 64-y2 == 11) || (96-x2 == 33 && 64-y2 == 12) || (96-x2 == 34 && 64-y2 == 12) || (96-x2 == 35 && 64-y2 == 12) || (96-x2 == 36 && 64-y2 == 12) || (96-x2 == 33 && 64-y2 == 13) || (96-x2 == 36 && 64-y2 == 13) || (96-x2 == 33 && 64-y2 == 14) || (96-x2 == 36 && 64-y2 == 14) || (96-x2 == 38 && 64-y2 == 10) || (96-x2 == 42 && 64-y2 == 10) || (96-x2 == 38 && 64-y2 == 11) || (96-x2 == 39 && 64-y2 == 11) || (96-x2 == 41 && 64-y2 == 11) || (96-x2 == 42 && 64-y2 == 11) || (96-x2 == 38 && 64-y2 == 12) || (96-x2 == 40 && 64-y2 == 12) || (96-x2 == 42 && 64-y2 == 12) || (96-x2 == 38 && 64-y2 == 13) || (96-x2 == 42 && 64-y2 == 13) || (96-x2 == 38 && 64-y2 == 14) || (96-x2 == 42 && 64-y2 == 14) || (96-x2 == 44 && 64-y2 == 10) || (96-x2 == 45 && 64-y2 == 10) || (96-x2 == 46 && 64-y2 == 10) || (96-x2 == 47 && 64-y2 == 10) || (96-x2 == 44 && 64-y2 == 11) || (96-x2 == 44 && 64-y2 == 12) || (96-x2 == 45 && 64-y2 == 12) || (96-x2 == 46 && 64-y2 == 12) || (96-x2 == 47 && 64-y2 == 12) || (96-x2 == 44 && 64-y2 == 13) || (96-x2 == 44 && 64-y2 == 14) || (96-x2 == 45 && 64-y2 == 14) || (96-x2 == 46 && 64-y2 == 14) || (96-x2 == 47 && 64-y2 == 14) || (96-x2 == 51 && 64-y2 == 10) || (96-x2 == 52 && 64-y2 == 10) || (96-x2 == 50 && 64-y2 == 11) || (96-x2 == 53 && 64-y2 == 11) || (96-x2 == 50 && 64-y2 == 12) || (96-x2 == 53 && 64-y2 == 12) || (96-x2 == 50 && 64-y2 == 13) || (96-x2 == 53 && 64-y2 == 13) || (96-x2 == 51 && 64-y2 == 14) || (96-x2 == 52 && 64-y2 == 14) || (96-x2 == 55 && 64-y2 == 10) || (96-x2 == 59 && 64-y2 == 10) || (96-x2 == 55 && 64-y2 == 11) || (96-x2 == 59 && 64-y2 == 11) || (96-x2 == 55 && 64-y2 == 12) || (96-x2 == 59 && 64-y2 == 12) || (96-x2 == 56 && 64-y2 == 13) || (96-x2 == 58 && 64-y2 == 13) || (96-x2 == 57 && 64-y2 == 14) || (96-x2 == 61 && 64-y2 == 10) || (96-x2 == 62 && 64-y2 == 10) || (96-x2 == 63 && 64-y2 == 10) || (96-x2 == 64 && 64-y2 == 10) || (96-x2 == 61 && 64-y2 == 11) || (96-x2 == 61 && 64-y2 == 12) || (96-x2 == 62 && 64-y2 == 12) || (96-x2 == 63 && 64-y2 == 12) || (96-x2 == 64 && 64-y2 == 12) || (96-x2 == 61 && 64-y2 == 13) || (96-x2 == 61 && 64-y2 == 14) || (96-x2 == 62 && 64-y2 == 14) || (96-x2 == 63 && 64-y2 == 14) || (96-x2 == 64 && 64-y2 == 14) || (96-x2 == 66 && 64-y2 == 10) || (96-x2 == 67 && 64-y2 == 10) || (96-x2 == 68 && 64-y2 == 10) || (96-x2 == 66 && 64-y2 == 11) || (96-x2 == 69 && 64-y2 == 11) || (96-x2 == 66 && 64-y2 == 12) || (96-x2 == 67 && 64-y2 == 12) || (96-x2 == 68 && 64-y2 == 12) || (96-x2 == 66 && 64-y2 == 13) || (96-x2 == 68 && 64-y2 == 13) || (96-x2 == 66 && 64-y2 == 14) || (96-x2 == 69 && 64-y2 == 14))) begin
                                                                        yoled_data2 <= WHITE ;
                                                                      end
                                                                      else
                                                                      yoled_data2 <=  partycolor ;
                                                         end
                                                  
        
         end
         
         
         else if (gamestate == 7) begin // running custom game 
             showdisplay <= 0; 
                if (pixel_index == (96*(scaled_y_pos-1)+cmovingx) && memory[pixel_index] == 1 )
                                         begin
                                             startcustclock <= 0;
                                             gamestate <= 6; 
                                         end
                 else if (x > cmovingx-1 &&  x < cmovingx +2 && y > scaled_y_pos-1 && y < scaled_y_pos+2) begin
                                        yoled_data <= (remembercolor) ? GREEN : WHITE;
                                      end
                  else if ( x<95 && x >70) yoled_data <= BLUE ; 
                  else if ( x >= 0 && x < 10) yoled_data <= GREEN; 
                  else if (memory[pixel_index] == 1) 
                            yoled_data <= customcolor;
                  
                  else yoled_data <= (sw[7])? partycolor : BLACK; 
                   
                  startcustclock <= 1; 
                  if ( cmovingx >= 0 && cmovingx < 10) begin
                  startcustclock <= 0;
                    gamestate <= 5; // win game
                    end
                   
                           //2nd player part ////////////////////
                                  
                                  
                                  
                                if (sw[14])begin
                                  
                                               if (pixel_index2 == (96*(scaled_y_pos2-1)+cmovingx) && memory[pixel_index2] == 1 )
                                                                           begin
                                                                               startcustclock <= 0;
                                                                               gamestate2 <= 6; 
                                                                           end
                                                   else if (x > cmovingx-1 &&  x < cmovingx +2 && y > scaled_y_pos2-1 && y < scaled_y_pos2+2) begin
                                                                          yoled_data2 <= (remembercolor) ? GREEN : WHITE;
                                                                        end
                                                    else if ( x<95 && x >70) yoled_data2 <= BLUE ; 
                                                    else if ( x >= 0 && x < 10) yoled_data2 <= GREEN; 
                                                    else if (memory[pixel_index2] == 1) 
                                                              yoled_data2 <= customcolor;
                                                    
                                                    else yoled_data2 <=  BLACK; 
                                                     
                                                    startcustclock <= 1; 
                                                    if ( cmovingx >= 0 && cmovingx < 10) begin
                                                    startcustclock <= 0;
                                                      gamestate2 <= 5; // win game
                                                      end
                      
                                            end
                                  
                                  if (sw[14] && gamestate2 == 5) begin //player 2 win game
                                  
                                  
                                                       if ( x2>=28 && x2 <=32 && y2 >= 10 && y2 <= 20) yoled_data2 <= GREEN ; 
                                                       else if ( x2>=62 && x2 <=67 && y2 >= 10 && y2 <= 20) yoled_data2 <= GREEN ;  // med box2
                                                       else if ( x2>=38 && x2 <=42 && y2 >= 30 && y2 <= 40) yoled_data2 <= GREEN ;   // hard box2
                                                       else if ( x2>=52 && x2 <=57 && y2 >= 30 && y2 <= 40) yoled_data2 <= GREEN ; 
                                                       else if ( x2>=33 && x2 <=62 && y2 >= 10 && y2 <= 13) yoled_data2 <= GREEN ;   // hard box2
                                                       else if (((96-x2 == 32 && 64-y2 == 10) || (96-x2 == 33 && 64-y2 == 10) || (96-x2 == 34 && 64-y2 == 10) || (96-x2 == 31 && 64-y2 == 11) || (96-x2 == 31 && 64-y2 == 12) || (96-x2 == 33 && 64-y2 == 12) || (96-x2 == 34 && 64-y2 == 12) || (96-x2 == 35 && 64-y2 == 12) || (96-x2 == 31 && 64-y2 == 13) || (96-x2 == 35 && 64-y2 == 13) || (96-x2 == 32 && 64-y2 == 14) || (96-x2 == 33 && 64-y2 == 14) || (96-x2 == 34 && 64-y2 == 14) || (96-x2 == 38 && 64-y2 == 10) || (96-x2 == 39 && 64-y2 == 10) || (96-x2 == 37 && 64-y2 == 11) || (96-x2 == 40 && 64-y2 == 11) || (96-x2 == 37 && 64-y2 == 12) || (96-x2 == 40 && 64-y2 == 12) || (96-x2 == 37 && 64-y2 == 13) || (96-x2 == 40 && 64-y2 == 13) || (96-x2 == 38 && 64-y2 == 14) || (96-x2 == 39 && 64-y2 == 14) || (96-x2 == 43 && 64-y2 == 10) || (96-x2 == 44 && 64-y2 == 10) || (96-x2 == 42 && 64-y2 == 11) || (96-x2 == 45 && 64-y2 == 11) || (96-x2 == 42 && 64-y2 == 12) || (96-x2 == 45 && 64-y2 == 12) || (96-x2 == 42 && 64-y2 == 13) || (96-x2 == 45 && 64-y2 == 13) || (96-x2 == 43 && 64-y2 == 14) || (96-x2 == 44 && 64-y2 == 14) || (96-x2 == 47 && 64-y2 == 10) || (96-x2 == 48 && 64-y2 == 10) || (96-x2 == 49 && 64-y2 == 10) || (96-x2 == 47 && 64-y2 == 11) || (96-x2 == 50 && 64-y2 == 11) || (96-x2 == 47 && 64-y2 == 12) || (96-x2 == 50 && 64-y2 == 12) || (96-x2 == 47 && 64-y2 == 13) || (96-x2 == 50 && 64-y2 == 13) || (96-x2 == 47 && 64-y2 == 14) || (96-x2 == 48 && 64-y2 == 14) || (96-x2 == 49 && 64-y2 == 14) || (96-x2 == 53 && 64-y2 == 10) || (96-x2 == 54 && 64-y2 == 10) || (96-x2 == 55 && 64-y2 == 10) || (96-x2 == 55 && 64-y2 == 11) || (96-x2 == 55 && 64-y2 == 12) || (96-x2 == 53 && 64-y2 == 13) || (96-x2 == 55 && 64-y2 == 13) || (96-x2 == 54 && 64-y2 == 14) || (96-x2 == 58 && 64-y2 == 10) || (96-x2 == 59 && 64-y2 == 10) || (96-x2 == 57 && 64-y2 == 11) || (96-x2 == 60 && 64-y2 == 11) || (96-x2 == 57 && 64-y2 == 12) || (96-x2 == 60 && 64-y2 == 12) || (96-x2 == 57 && 64-y2 == 13) || (96-x2 == 60 && 64-y2 == 13) || (96-x2 == 58 && 64-y2 == 14) || (96-x2 == 59 && 64-y2 == 14) || (96-x2 == 62 && 64-y2 == 10) || (96-x2 == 63 && 64-y2 == 10) || (96-x2 == 64 && 64-y2 == 10) || (96-x2 == 62 && 64-y2 == 11) || (96-x2 == 65 && 64-y2 == 11) || (96-x2 == 62 && 64-y2 == 12) || (96-x2 == 63 && 64-y2 == 12) || (96-x2 == 64 && 64-y2 == 12) || (96-x2 == 62 && 64-y2 == 13) || (96-x2 == 65 && 64-y2 == 13) || (96-x2 == 62 && 64-y2 == 14) || (96-x2 == 63 && 64-y2 == 14) || (96-x2 == 64 && 64-y2 == 14))) begin
                                                          yoled_data2 <= WHITE;
                                                       end
                                                       else 
                                                       yoled_data2 <=  partycolor ;
                                  
                                       end
                             
                            
                    
                            
                            
                                   if (sw[14] && gamestate2 == 6) begin
                            
                                                 if ( x2>=28 && x2 <=32 && y2 >= 0 && y2 <= 10) yoled_data2 <= RED ; //easy2 box2
                                                 else if ( x2>=62 && x2 <=67 && y2 >= 0 && y2 <= 10) yoled_data2 <= RED ;  // med box2
                                                 else if ( x2>=38 && x2 <=42 && y2 >= 20 && y2 <= 40) yoled_data2 <= RED ;   // hard box2
                                                 else if ( x2>=52 && x2 <=57 && y2 >= 20 && y2 <= 40) yoled_data2 <= RED ; 
                                                 else if ( x2>=33 && x2 <=62 && y2 >= 7 && y2 <= 10) yoled_data2 <= RED ;   // hard box2
                                                 else if (((96-x2 == 28 && 64-y2 == 10) || (96-x2 == 29 && 64-y2 == 10) || (96-x2 == 30 && 64-y2 == 10) || (96-x2 == 27 && 64-y2 == 11) || (96-x2 == 27 && 64-y2 == 12) || (96-x2 == 29 && 64-y2 == 12) || (96-x2 == 30 && 64-y2 == 12) || (96-x2 == 31 && 64-y2 == 12) || (96-x2 == 27 && 64-y2 == 13) || (96-x2 == 31 && 64-y2 == 13) || (96-x2 == 28 && 64-y2 == 14) || (96-x2 == 29 && 64-y2 == 14) || (96-x2 == 30 && 64-y2 == 14) || (96-x2 == 34 && 64-y2 == 10) || (96-x2 == 35 && 64-y2 == 10) || (96-x2 == 33 && 64-y2 == 11) || (96-x2 == 36 && 64-y2 == 11) || (96-x2 == 33 && 64-y2 == 12) || (96-x2 == 34 && 64-y2 == 12) || (96-x2 == 35 && 64-y2 == 12) || (96-x2 == 36 && 64-y2 == 12) || (96-x2 == 33 && 64-y2 == 13) || (96-x2 == 36 && 64-y2 == 13) || (96-x2 == 33 && 64-y2 == 14) || (96-x2 == 36 && 64-y2 == 14) || (96-x2 == 38 && 64-y2 == 10) || (96-x2 == 42 && 64-y2 == 10) || (96-x2 == 38 && 64-y2 == 11) || (96-x2 == 39 && 64-y2 == 11) || (96-x2 == 41 && 64-y2 == 11) || (96-x2 == 42 && 64-y2 == 11) || (96-x2 == 38 && 64-y2 == 12) || (96-x2 == 40 && 64-y2 == 12) || (96-x2 == 42 && 64-y2 == 12) || (96-x2 == 38 && 64-y2 == 13) || (96-x2 == 42 && 64-y2 == 13) || (96-x2 == 38 && 64-y2 == 14) || (96-x2 == 42 && 64-y2 == 14) || (96-x2 == 44 && 64-y2 == 10) || (96-x2 == 45 && 64-y2 == 10) || (96-x2 == 46 && 64-y2 == 10) || (96-x2 == 47 && 64-y2 == 10) || (96-x2 == 44 && 64-y2 == 11) || (96-x2 == 44 && 64-y2 == 12) || (96-x2 == 45 && 64-y2 == 12) || (96-x2 == 46 && 64-y2 == 12) || (96-x2 == 47 && 64-y2 == 12) || (96-x2 == 44 && 64-y2 == 13) || (96-x2 == 44 && 64-y2 == 14) || (96-x2 == 45 && 64-y2 == 14) || (96-x2 == 46 && 64-y2 == 14) || (96-x2 == 47 && 64-y2 == 14) || (96-x2 == 51 && 64-y2 == 10) || (96-x2 == 52 && 64-y2 == 10) || (96-x2 == 50 && 64-y2 == 11) || (96-x2 == 53 && 64-y2 == 11) || (96-x2 == 50 && 64-y2 == 12) || (96-x2 == 53 && 64-y2 == 12) || (96-x2 == 50 && 64-y2 == 13) || (96-x2 == 53 && 64-y2 == 13) || (96-x2 == 51 && 64-y2 == 14) || (96-x2 == 52 && 64-y2 == 14) || (96-x2 == 55 && 64-y2 == 10) || (96-x2 == 59 && 64-y2 == 10) || (96-x2 == 55 && 64-y2 == 11) || (96-x2 == 59 && 64-y2 == 11) || (96-x2 == 55 && 64-y2 == 12) || (96-x2 == 59 && 64-y2 == 12) || (96-x2 == 56 && 64-y2 == 13) || (96-x2 == 58 && 64-y2 == 13) || (96-x2 == 57 && 64-y2 == 14) || (96-x2 == 61 && 64-y2 == 10) || (96-x2 == 62 && 64-y2 == 10) || (96-x2 == 63 && 64-y2 == 10) || (96-x2 == 64 && 64-y2 == 10) || (96-x2 == 61 && 64-y2 == 11) || (96-x2 == 61 && 64-y2 == 12) || (96-x2 == 62 && 64-y2 == 12) || (96-x2 == 63 && 64-y2 == 12) || (96-x2 == 64 && 64-y2 == 12) || (96-x2 == 61 && 64-y2 == 13) || (96-x2 == 61 && 64-y2 == 14) || (96-x2 == 62 && 64-y2 == 14) || (96-x2 == 63 && 64-y2 == 14) || (96-x2 == 64 && 64-y2 == 14) || (96-x2 == 66 && 64-y2 == 10) || (96-x2 == 67 && 64-y2 == 10) || (96-x2 == 68 && 64-y2 == 10) || (96-x2 == 66 && 64-y2 == 11) || (96-x2 == 69 && 64-y2 == 11) || (96-x2 == 66 && 64-y2 == 12) || (96-x2 == 67 && 64-y2 == 12) || (96-x2 == 68 && 64-y2 == 12) || (96-x2 == 66 && 64-y2 == 13) || (96-x2 == 68 && 64-y2 == 13) || (96-x2 == 66 && 64-y2 == 14) || (96-x2 == 69 && 64-y2 == 14))) begin
                                                   yoled_data2 <= WHITE ;
                                                 end
                                                 else
                                                 yoled_data2 <=  partycolor ;
                                    end
                             
         
 
         end
         
                        
          //reset drawing function
          if(reset) begin
                     memory <= 6144'b0; 
                     gamestate <= 0; 
                     choice <= 3'b0;
                     starteasyclock <= 0;
                     startmedclock <= 0;
                     starthardclock <= 0;
                     startcustclock <= 0;
                     showdisplay <= 0;
                     gamestate2 <= 0;
                
          end
                                   
         end //end the sw[13] is on
  
            
         x <= x+1;
         y <= y+1;
          x2 <= x2+1;
                 y2 <= y2+1;
 

            end
       
        
        
        
        
        
//easy mode obeject movement

always @ (posedge clk10hz) begin
    if (starteasyclock == 1) begin
        movingx <= movingx - 1;
    end
    else begin
        movingx <= 90;
    end

end    
        
always @ (posedge mclock) begin
    if (startmedclock == 1) begin
        mmovingx <= mmovingx - 1;
    end
    else begin
        mmovingx <= 90;
    end

end     

always @ (posedge hclock) begin
    if (starthardclock == 1) begin
        hmovingx <= hmovingx - 1;
    end
    else begin
        hmovingx <= 90;
    end

end    

always @ (posedge cclock) begin
    if (startcustclock == 1) begin
        cmovingx <= cmovingx - 1;
    end
    else begin
        cmovingx <= 90;
    end

end  
        
        
        
        
        
        
        
        
        
        
 //show the difficult when mouse over the colored square in menu page      
            
always @ (posedge clk10khz)
begin
    if (showdisplay == 0) begin
                    anode[3:0] <= 4'b1111;
                    segment[6:0] <= 7'b1111111;
                    dot <= 1'b1;
    
    end 
    else if (showdisplay == 1) begin
        if (gamestate == 5) begin // display yay
            if (count == 0) begin   
                        anode[3:0] <= 4'b0111;
                        segment[6:0] <= 7'b0010001;
                        dot <= 1'b1;
                    
              end
              else if (count == 14) begin   
                      anode[3:0] <= 4'b1011;
                      segment[6:0] <= 7'b0001000;
                      dot <= 1'b1;
                  
              end
              else if (count == 28) begin   
                      anode[3:0] <= 4'b1101;
                      segment[6:0] <= 7'b0010001;
                      dot <= 1'b1;
                  
              end
        end
    
        else if (gamestate == 6) begin   //loose game and show boo
                if (count == 0) begin   
                            anode[3:0] <= 4'b0111;
                            segment[6:0] <= 7'b0000011;
                            dot <= 1'b1;
                        
                  end
                  else if (count == 14) begin   
                          anode[3:0] <= 4'b1011;
                          segment[6:0] <= 7'b0100011;
                          dot <= 1'b1;
                      
                  end
                  else if (count == 28) begin   
                          anode[3:0] <= 4'b1101;
                          segment[6:0] <= 7'b0100011;
                          dot <= 1'b1;
                      
                  end
                end






        else if (gamestate == 0 && (choice == 1 || choice == 2 || choice == 3) ) begin //menu page
            if (count == 0 || count == 28) begin   
                    anode[3:0] = 4'b0111;
                    segment[6:0] = 7'b1000111;
                    dot <= 1'b1;
                
            end
            
            else if (count == 14 || count == 42) begin
                    if (choice == 1)
                    begin
                        anode[3:0] <= 4'b1011;
                        segment[6:0] <= 7'b1111001;
                        dot <= 1'b1;
                    end
                    else if (choice == 2)
                    begin
                        anode[3:0] <= 4'b1011;
                        segment[6:0] <= 7'b0100100;
                        dot <= 1'b1;
                    end
                    else if (choice == 3)
                    begin
                        anode[3:0] <= 4'b1011;
                        segment[6:0] <= 7'b0110000;
                        dot <= 1'b1;
                    end
                
                    else
                    begin
                        segment[6:0] <= 7'b1111111;
                        dot <= 1'b1;
                        anode <= 4'b1111;
                    end
            end
                    
      end
      
      
      else if (gamestate == 0 && choice == 4 ) begin  //menu page part 2
                  if (count == 0) begin   
                          anode[3:0] <= 4'b0111;
                          segment[6:0] <= 7'b1000110;
                          dot <= 1'b1;
                      
                  end
                  else if (count == 14) begin   
                        anode[3:0] <= 4'b1011;
                        segment[6:0] <= 7'b1000001;
                        dot <= 1'b1;
                    
                end
                else if (count == 28) begin   
                        anode[3:0] <= 4'b1101;
                        segment[6:0] <= 7'b0010010;
                        dot <= 1'b1;
                    
                end
                else if (count == 42) begin   
                        anode[3:0] <= 4'b1110;
                        segment[6:0] <= 7'b0000111;
                        dot <= 1'b1;
                    
               end
                  
                          
        end //end menu page part 2
   end // end show display == 1
   
   end // end always at posedge clock
 
endmodule







// mouse output scaler to fit into display bits

module x_scaler (
input clock, input [11:0]in, output reg [7:0]out
);
reg[11:0] in1 = 12'b0;
always @ (posedge clock)    
    begin
    in1 = in / 4 ;
    out = in1;
    end

endmodule

module y_scaler (
input clock, input [11:0
]in, output reg [7:0]out
);
reg[11:0] in1 = 12'b0;
always @ (posedge clock)    
    begin
    in1 = in / 4 ;
    out = in1;
    end

endmodule




