`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2023 14:11:00
// Design Name: 
// Module Name: mainmain
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





module mainmain(
    input btnR, input btnL, input btnD, input btnU, input clock, inout PS2Clk, inout PS2Data, input btnC,  input [15:0] sw,
    output [7:0] JXADC, output[7:0] JC, output reg [15:0]led , output reg [3:0] an, output reg [6:0] seg , output reg dp, output [3:0]JA,
    input J_MIC_Pin3, 
    output J_MIC_Pin1,
    output J_MIC_Pin4
    );
    
    wire [15:0] yoled_data;
    wire [15:0] yoled_data2;
    wire [15:0] moled_data;
    wire [15:0] oled_data;
    wire [15:0] oled_data2;
    wire [15:0] joled_data;
    reg [3:0] menupage = 3'b0;
    wire [7:0]jxadc;
    wire [15:0]light;
    wire  [6:0] segment;
    wire  dot;
    wire  [3:0]ja;
    reg [2:0] menustate = 0;
    
    reg   trigger_main = 0;
    reg  trigger_yongrui = 0;
    
    //yong rui mod output wires
    wire [15:0] ylight;
    wire [3:0] yanode; 
    wire [6:0]ysegment;
    wire  ybtnR,  ybtnL,  yreset, ysw;
    wire menuclk, yrtrigger;
    
    wire [11:0] maudio_out;
      
    wire audiotrigger;  
    wire [11:0] sample;
    // sound in
    wire clk20khz;
    my_20khz_clock
    unit_clock20khz (clock, clk20khz);       // clock to take in the sample
                        
    Audio_Input(clock, clk20khz, J_MIC_Pin3, J_MIC_Pin1, J_MIC_Pin4, sample);
    
    //all the audio_out stuff 
    wire clk50M;
    my_50Mhz_clock unit_clock_50MHz(clock, clk50M);   
    wire clk20k;
    my_20khz_clock unit_clock_20khz(clock, clk20k);
    wire clk190;    
    my_190hz_clock unit_clock_190hz(clock, clk190);    
    wire clk380;    
    my_380hz_clock unit_clock_380hz(clock, clk380);
    
    wire rst;
    wire [11:0] audio_out;
    wire [3:0] musanode;
    wire [6:0] mussegment;
    wire [11:0] must_audio_out;
    wire [11:0] main_audio_out;
    
    wire [1:0] reset_islegitnum;
    wire [1:0] islegitnum;
    wire [3:0] thelegitnum;
            
    parameter RED = 16'hF800;
    parameter GREEN = 16'h07E0;
    parameter BLACK = 16'h0;
    parameter WHITE = ~BLACK;
    parameter YELLOW = 16'b11111_111111_01101;  
    parameter ORANGE = 16'b11111_101010_00110;
    parameter BLUE = 16'b00101_011010_11000;
    
    
    Audio_Output audio_output (   .CLK(clk50M),  
                                 .START(clk20k),  
                                 .DATA1(audio_out),  
                                 .RST(rst),
                                 .D1(JA[1]),
                                 .D2(JA[2]),
                                 .CLK_OUT(JA[3]),
                                 .nSYNC(JA[0])
                                 );
    
    mustafa mustafa(clock, clk190, clk380, btnC, btnL, btnU, sw, islegitnum, thelegitnum, musanode, mussegment, must_audio_out);
    
    reg [11:0] audio_out_chooser;
    assign audio_out = audio_out_chooser;
    
    wire clk6p25m;
    clk6p25m clk6p25 (clock, clk6p25m);
    wire [12:0] pixel_index;
    wire [12:0] pixel_index2;
    
    //main page output wires
    wire mjxadc ,  mdot,  mja, mjmicpin3,mjmicpin1, mjmicpin4, mtrigger_main;
    wire [15:0] mlight;
    wire [3:2] manode;
    wire [6:0] msegment;
    
    wire middletrigger;
    wire righttrigger;
    wire lefttrigger;
    
    wire midclick;
    wire rightclick;
    wire leftclick;

    wire [11:0] x_pos;
    wire [11:0] y_pos;

    debounce (clock, midclick, middletrigger);
    debounce (clock, rightclick, righttrigger);
    debounce (clock, leftclick, lefttrigger);
     
       
     MouseCtl mousemod(
        .clk(clock),
        .ps2_clk(PS2Clk),
        .ps2_data(PS2Data),
        .middle(midclick),
        .right(rightclick),
        .left(leftclick),
        .xpos(x_pos),
        .ypos(y_pos)
             
    );
    
        wire [7:0] out_x_pos;
        wire [7:0]  out_y_pos;
        x_scaler scalex (clock, x_pos,out_x_pos);
        y_scaler scaley (clock, y_pos, out_y_pos);
        
        wire[15:0] jled;
        wire [9:0] is;
        wire [25:0] letter;
                 
        yongrui yr(  btnR,  btnL,  clock,  PS2Clk,  PS2Data,  btnC , sw,  ylight ,  yanode,  ysegment , yoled_data,yoled_data2, pixel_index, pixel_index2, out_x_pos, out_y_pos , rightclick, lefttrigger, middletrigger);
        Jerald jerald (.clock(clock), .btnC(btnC), .JB(JC), .sw(sw), .btnR(btnR), .led(jled), .jeroled_data(joled_data ), . pixel_index(pixel_index2 ));
        
        Top_Student topstudent(btnR,  btnL,  clock,  PS2Clk,  PS2Data,  btnC, sw,  mlight ,  manode,  msegment ,  mdot, moled_data, pixel_index, out_x_pos, out_y_pos , righttrigger, lefttrigger, middletrigger, sample, main_audio_out, is, letter);
        
        reg [15:0] mmoled_data;
        
        
        reg receiver_state = 0;
        wire [15:0] doled_data;
        wire enable_deen_task;
        wire enable_morse;
        wire enable_frequency_checker;
        wire on_freq_led;
        wire on_morse_led;
        deen_toggle (clock, sw, receiver_state, enable_deen_task, enable_morse, enable_frequency_checker, on_freq_led, on_morse_led, pixel_index, doled_data);
                
        wire [8:0] dt_led;    
        wire dt_an;
        wire [6:0] dt_seg;
        deen_task(clock, sample, enable_deen_task, dt_led, dt_an, dt_seg);
        
        wire [15:0] deen_led;
        wire [3:0] deen_an;
        wire [6:0] deen_seg;
        deen(clock, sw[0], btnC, sample, enable_morse, enable_frequency_checker, on_freq_led, on_morse_led, deen_led, deen_an, deen_seg);     
                
        wire custclock;        
        d_flexible_clock (clock, 4999, custclock);
        
        reg [1:0]count;     // only count 0 and 1
        wire clk10khz;
        clk10khz clk10khz_output (clock, clk10khz) ; 
        
        
        reg [6:0] sseg;
        reg [7:0] fseg;
        wire [11:0]  oaudio_out; 
        
        always @ (posedge custclock)
        begin
        
                count <= count + 1;
        end
        
       // implement receiver state
       always @ (posedge clock) 
       begin
            if (sw == 16'b0001001000000000 || sw == 16'b0001001000000001 )
            begin
                receiver_state <= 1;
            end
            else 
            begin
                receiver_state <= 0;
            end 
       end
        
        // for 
        always @ (posedge custclock)
        begin
//            if (sw == 0)        // for group task
            if (~sw[13] && ~sw[12] && ~sw[11] && ~sw[10] )        // for group task  
            begin 
                case (count)
                0: 
                    begin    // deens value
                        
                         an <= 4'b1110;
                         seg <= dt_seg;
                         dp <= 1;
                    end
                
                1:
                   begin
                        an <= 4'b0111;
                        seg = fseg;
                        dp <= (is == 0 )? 1 : 0;
                    end
                2:
                    begin
                         an <= 4'b1011;
                         seg <= sseg;
                          dp <= 1;
                    end
                3:
                    begin
                         an <= 4'b1011;
                         seg <= sseg;
                          dp <= 1;
                    end             
                
                endcase
                
                led[8:0] <= dt_led;
                led[15:9] <= mlight[15:9];
                audio_out_chooser <= oaudio_out;
                
            end
            
            else if (menustate == 3)       // yongrui improvement
            begin
                an <= yanode;
                led <= ylight;
                seg <= ysegment;
                audio_out_chooser <= 0;
            end     
            
            else if (menustate == 1 || receiver_state == 1)       // deen improvement
            begin
                an <= deen_an;
               led <= deen_led;
               seg <= deen_seg;
               audio_out_chooser <= 0;
            end
            
            else if (menustate == 2)       // mustafa improvement
            begin
                an <= musanode;
                seg <= mussegment;
                audio_out_chooser <= must_audio_out;
            end
            
            else if (menustate == 4)       // jerald improvement
            begin
                led <= jled;
                audio_out_chooser <= 0;
            end
            
        end
        
//        assign led = sw[13] ?  ylight : (sw[12] == 1 ? deen_led : mlight);        
//        assign seg = (sw[13]) ? ysegment : (sw[12] == 1 ? deen_seg :msegment);

        //assign audio_out = (sw[13])? 0 : maudio_out;    
//        assign oled_data = (menustate == 0 && ~sw[8]) ? mmoled_data : (menustate == 0 && sw[8])? moled_data : (menustate == 1)? yoled_data : 0;
        assign oled_data = (menustate == 0 && ~sw[8]) ? mmoled_data : (menustate == 0 && sw[8])? moled_data : (menustate == 3)? yoled_data : (menustate == 1 || receiver_state == 1)? doled_data : 0;
        assign oled_data2 = (menustate == 3) ? yoled_data2 : (menustate == 4)? joled_data : 0;
  
  
        Oled_Display( .clk(clk6p25m), .reset(~sw[15]), .pixel_data(oled_data), .cs(JXADC[0]), .sdin(JXADC[1]), .sclk(JXADC[3]),
                      .d_cn(JXADC[4]), .resn(JXADC[5]), .vccen(JXADC[6]), .pmoden(JXADC[7]), .pixel_index(pixel_index));
        
     //jerald oled   
        Oled_Display(
                              .clk(clk6p25m), .reset(~sw[15]), .pixel_data(oled_data2), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]),
                              .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]), .pixel_index(pixel_index2));    
     
        
        audiocontrol(
                       clock,
                       sw[15],
                       sw[7],
                       sw[0],
                       is, letter,
                        oaudio_out
                       );
                          
           
       
        reg [7:0] x,y ;  
        reg [7:0]scaled_x_pos, scaled_y_pos;   
        reg[1:0] remembercolor = 1'b0;   
           
                  
        always @ (posedge clock) begin
        
        
            if (btnD) menustate <= 0;
            
            x = pixel_index % 96;
            y = pixel_index / 96;
            scaled_x_pos =  96 - ((out_x_pos>95)? 95 : (out_x_pos<1)? 1 : out_x_pos)  ;
            scaled_y_pos = 64 - ((out_y_pos>63)? 63 : (out_y_pos<1)? 1 : out_y_pos) ; 
                     
            if (menustate == 0) begin
            
            if (x > scaled_x_pos-1 && x < scaled_x_pos+2 && y > scaled_y_pos-1 && y < scaled_y_pos+2 ) 
                                                           mmoled_data <= (remembercolor) ? GREEN : ~WHITE;
                             
            //write out "welcome"
            else if (((96-x == 30 && 64-y == 10) || (96-x == 34 && 64-y == 10) || (96-x == 30 && 64-y == 11) || (96-x == 34 && 64-y == 11) || (96-x == 30 && 64-y == 12) || (96-x == 34 && 64-y == 12) || (96-x == 30 && 64-y == 13) || (96-x == 32 && 64-y == 13) || (96-x == 34 && 64-y == 13) || (96-x == 31 && 64-y == 14) || (96-x == 33 && 64-y == 14) || (96-x == 36 && 64-y == 10) || (96-x == 37 && 64-y == 10) || (96-x == 38 && 64-y == 10) || (96-x == 39 && 64-y == 10) || (96-x == 36 && 64-y == 11) || (96-x == 36 && 64-y == 12) || (96-x == 37 && 64-y == 12) || (96-x == 38 && 64-y == 12) || (96-x == 39 && 64-y == 12) || (96-x == 36 && 64-y == 13) || (96-x == 36 && 64-y == 14) || (96-x == 37 && 64-y == 14) || (96-x == 38 && 64-y == 14) || (96-x == 39 && 64-y == 14) || (96-x == 41 && 64-y == 10) || (96-x == 41 && 64-y == 11) || (96-x == 41 && 64-y == 12) || (96-x == 41 && 64-y == 13) || (96-x == 41 && 64-y == 14) || (96-x == 42 && 64-y == 14) || (96-x == 43 && 64-y == 14) || (96-x == 44 && 64-y == 14) || (96-x == 47 && 64-y == 10) || (96-x == 48 && 64-y == 10) || (96-x == 46 && 64-y == 11) || (96-x == 49 && 64-y == 11) || (96-x == 46 && 64-y == 12) || (96-x == 46 && 64-y == 13) || (96-x == 49 && 64-y == 13) || (96-x == 47 && 64-y == 14) || (96-x == 48 && 64-y == 14) || (96-x == 52 && 64-y == 10) || (96-x == 53 && 64-y == 10) || (96-x == 51 && 64-y == 11) || (96-x == 54 && 64-y == 11) || (96-x == 51 && 64-y == 12) || (96-x == 54 && 64-y == 12) || (96-x == 51 && 64-y == 13) || (96-x == 54 && 64-y == 13) || (96-x == 52 && 64-y == 14) || (96-x == 53 && 64-y == 14) || (96-x == 56 && 64-y == 10) || (96-x == 60 && 64-y == 10) || (96-x == 56 && 64-y == 11) || (96-x == 57 && 64-y == 11) || (96-x == 59 && 64-y == 11) || (96-x == 60 && 64-y == 11) || (96-x == 56 && 64-y == 12) || (96-x == 58 && 64-y == 12) || (96-x == 60 && 64-y == 12) || (96-x == 56 && 64-y == 13) || (96-x == 60 && 64-y == 13) || (96-x == 56 && 64-y == 14) || (96-x == 60 && 64-y == 14) || (96-x == 62 && 64-y == 10) || (96-x == 63 && 64-y == 10) || (96-x == 64 && 64-y == 10) || (96-x == 65 && 64-y == 10) || (96-x == 62 && 64-y == 11) || (96-x == 62 && 64-y == 12) || (96-x == 63 && 64-y == 12) || (96-x == 64 && 64-y == 12) || (96-x == 65 && 64-y == 12) || (96-x == 62 && 64-y == 13) || (96-x == 62 && 64-y == 14) || (96-x == 63 && 64-y == 14) || (96-x == 64 && 64-y == 14) || (96-x == 65 && 64-y == 14))         ) begin
                       mmoled_data <= ~WHITE;
            end
            
            // name
            else if (((96-x == 24 && 64-y == 27) || (96-x == 23 && 64-y == 28) || (96-x == 24 && 64-y == 28) || (96-x == 24 && 64-y == 29) || (96-x == 24 && 64-y == 30) || (96-x == 23 && 64-y == 31) || (96-x == 24 && 64-y == 31) || (96-x == 25 && 64-y == 31))) begin
            mmoled_data <= ~BLACK;
            end
            
            // name
            else if (((96-x == 23 && 64-y == 52) || (96-x == 24 && 64-y == 52) || (96-x == 25 && 64-y == 52) || (96-x == 25 && 64-y == 53) || (96-x == 23 && 64-y == 54) || (96-x == 24 && 64-y == 54) || (96-x == 25 && 64-y == 54) || (96-x == 25 && 64-y == 55) || (96-x == 23 && 64-y == 56) || (96-x == 24 && 64-y == 56) || (96-x == 25 && 64-y == 56))) begin
            mmoled_data <= ~BLACK;
            end
            
            // name
            else if (((96-x == 71 && 64-y == 27) || (96-x == 72 && 64-y == 27) || (96-x == 73 && 64-y == 27) || (96-x == 73 && 64-y == 28) || (96-x == 71 && 64-y == 29) || (96-x == 72 && 64-y == 29) || (96-x == 73 && 64-y == 29) || (96-x == 71 && 64-y == 30) || (96-x == 71 && 64-y == 31) || (96-x == 72 && 64-y == 31) || (96-x == 73 && 64-y == 31))) begin
            mmoled_data <= ~BLACK;
            end
            
            // name
            
            else if (((96-x == 71 && 64-y == 52) || (96-x == 73 && 64-y == 52) || (96-x == 71 && 64-y == 53) || (96-x == 73 && 64-y == 53) || (96-x == 71 && 64-y == 54) || (96-x == 72 && 64-y == 54) || (96-x == 73 && 64-y == 54) || (96-x == 73 && 64-y == 55) || (96-x == 73 && 64-y == 56))) begin                       
            mmoled_data <= ~BLACK;
            end
            
            
            else if ( x>60 && x <84 && y > 27 && y < 47) mmoled_data <= YELLOW ; //easy box
            else if ( x > 12 && x < 36 && y > 27 && y < 47) mmoled_data <= ORANGE; // med box
            else if ( x>60 && x <84 && y > 2 && y < 22) mmoled_data <= RED ;  // hard box
            else if ( x > 12 && x < 36 && y > 2 && y < 22) mmoled_data <= BLUE; //cust box
            else 
            mmoled_data <= WHITE;
                            
                           
                            
            if (84 > scaled_x_pos-1 && 60 < scaled_x_pos+2 && 47 > scaled_y_pos-1 && 27 < scaled_y_pos+2 &&righttrigger ) // mouse click easy box
                                       menustate <= 1;
                                       
            else if (36 > scaled_x_pos-1 && 12 < scaled_x_pos+2 && 47 > scaled_y_pos-1 && 27 < scaled_y_pos+2 &&righttrigger ) // mouse click med box
                                                   menustate <= 2;
                                                   
            else if (84 > scaled_x_pos-1 && 60 < scaled_x_pos+2 && 22 > scaled_y_pos-1 && 2 < scaled_y_pos+2 &&righttrigger) // mouse click hard box
                                                   menustate <= 3;
                                       
            else if (36 > scaled_x_pos-1 && 12 < scaled_x_pos+2 && 22 > scaled_y_pos-1 && 2 < scaled_y_pos+2 &&righttrigger) // mouse click cust box
                                                   menustate <= 4;   
            else menustate <= 0;
            
            
        end
    
        if (is[0] == 1) begin
        sseg[6:0] <= 7'b1111001;
        fseg[6:0] <= 7'b1000000;  
        end
        
        else if (is[1]) begin
        sseg[6:0] <= 7'b0100100;
        fseg[6:0] <= 7'b1000000;  
        end
        else if (is[2]) begin
        sseg[6:0] <= 7'b0110000;
        fseg[6:0] <= 7'b1000000;  
        end
        
        else if (is[3]) begin
        sseg[6:0] <= 7'b0011001;
        fseg[6:0] <= 7'b1000000;  
        end
        else if (is[4]) begin
        sseg[6:0] <= 7'b0010010; 
        fseg[6:0] <= 7'b1000000;  
        end
        
        else if (is[5])begin
        sseg[6:0] <= 7'b0000010; 
        fseg[6:0] <= 7'b1000000;  
        end
        
        else if (is[6]) begin
        sseg[6:0] <= 7'b1111000;
        fseg[6:0] <= 7'b1000000;  
        end
        
        else if (is[7]) begin
        sseg[6:0] <= 7'b0000000;
        fseg[6:0] <= 7'b1000000;  
        end
        
        else if (is[8]) begin
        sseg[6:0] <= 7'b0011000;
        fseg[6:0] <= 7'b1000000;  
        end
        
        else if (is[9]) begin
        sseg[6:0] <= 7'b1000000;
        fseg[6:0] <= 7'b1111001;  
        end
        
        else begin
        sseg[6:0] <= 7'b1111111;
        fseg[6:0] <= 7'b1111111; 
        end
        
    end  //end clock
endmodule




module debounce (
    input clock, input in, output out

);

    reg val = 0;
    assign out = val;
    reg [31:0] count;
    
    
    always @ (posedge clock) begin
        count <= count +1;
        
        if (count % 12000000 == 0) begin
            if (in) begin
                val <= 1;
                end
                
             else val <= 0;
                
        end
        
        if (val == 1) begin
            val <= 0;
            end
    
    end

endmodule






















