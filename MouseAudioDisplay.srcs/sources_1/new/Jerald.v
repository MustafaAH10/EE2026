`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 13:17:20
// Design Name: 
// Module Name: Jerald
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


module Jerald(
    input clock, input btnC, output [7:0] JB, input [15:0] sw, input btnR
    , output reg [15:0] led, output [15:0] jeroled_data , input [12:0] pixel_index
    );
    
    parameter RED = 16'hF800;
        parameter GREEN = 16'h07E0;
        parameter BLACK = 16'h0;
        parameter WHITE = ~BLACK;
        
       
        
        wire clk6p25m;
        clk6p25m clk6p25m_output (clock, clk6p25m);
        reg [15:0] oled_data = BLACK;
        wire [12:0] pixel_index;
        reg [7:0] x, y, secret_num, guess;
        wire clock_1hz;
        wire [3:0]random_num;
        
         assign jeroled_data = oled_data;
        
        
        
    
    //    always @ (posedge clock) 
    //    begin
    //        oled_data = (sw[4]) ? RED : GREEN;
    //        oled_data = BLACK;
    //    end
        /*
        Oled_Display(
        .clk(clk6p25m), .reset(btnC), .pixel_data(oled_data), .cs(JB[0]), .sdin(JB[1]), .sclk(JB[3]),
        .d_cn(JB[4]), .resn(JB[5]), .vccen(JB[6]), .pmoden(JB[7]), .pixel_index(pixel_index));
        */
        
        //custom_clock clock1 (.clock(clock), .sum(49999999), .clock_output(clock_1hz));
        rand_num_gen randnum1 (.clock(clock), .reset(btnC), .Q(random_num));
        
    //    initial begin   
    //        secret_num = $urandom_range(10,0);
    //    end
        
        
        always @ (posedge clock)
        begin
        if (sw[4] && sw[10] == 0)
        begin
            x = pixel_index % 96;
            y = pixel_index / 96;
            
            oled_data = BLACK;
            
            if (x > 57 && x < 61 && y < 61)
            begin
                oled_data <= GREEN;
            end
            if (y > 57 && y < 61 && x < 61)
            begin
                oled_data <= GREEN;
            end
            
            x = x+1;
            y = y+1;
    
        end
        
        if (sw[1] && sw[7] == 0 && sw[0] == 0 && sw[10] == 0)
        begin
            x = pixel_index % 96;
            y = pixel_index / 96;
            
            oled_data = BLACK;
            
            if (x > 25 && x < 33 && y > 9 && y < 47) 
            begin
                oled_data <= WHITE;
            end 
            
            x = x+1;
            y = y+1;
        end
        
        if (sw[7] && sw[1] == 0 && sw[0] == 0 && sw[10] == 0)
        begin
            x = pixel_index % 96;
            y = pixel_index / 96;
            
            oled_data = BLACK;
            
            if (x > 10 && x < 43 && y > 9 && y < 18) 
            begin
                oled_data <= WHITE;
            end
            if (x > 34 && x < 43 && y > 16 && y < 48) 
            begin
                oled_data <= WHITE;
            end  
            
            x = x+1;
            y = y+1;
        end
        
        if (sw[0] && sw[1] == 0 && sw[7] == 0 && sw[10] == 0)
        begin
            x = pixel_index % 96;
            y = pixel_index / 96;
            
            oled_data = BLACK;
            
            if (x > 10 && x < 43 && y > 6 && y < 12) 
            begin
                oled_data <= WHITE;
            end
            if (x > 36 && x < 43 && y > 11 && y < 48) 
            begin
                oled_data <= WHITE;
            end
            if (x > 10 && x < 17 && y > 11 && y < 52) 
            begin
                oled_data <= WHITE;
            end
            if (x > 10 && x < 43 && y > 46 && y < 52) 
            begin
                oled_data <= WHITE;
            end  
            
            x = x+1;
            y = y+1;
        end
        
        
        if (sw[10])    
        begin
            x = pixel_index % 96;
            y = pixel_index / 96;
            guess = sw[5:0];
            oled_data = BLACK;
            
            led[0] = sw[0];
            led[1] = sw[1];
            led[2] = sw[2];
            led[3] = sw[3];
            
            if (btnR) //generate a random number
            begin
                secret_num = random_num; //guess from 1 to 15 
            end
            
            if (guess == secret_num)
            begin
                if (x > 5 && x < 11 && y > 10 && y < 54) //w
                begin
                    oled_data <= GREEN; //Green if correct
                end
                
                if (x > 10 && x < 20 && y > 49 && y < 54)//w
                begin
                    oled_data <= GREEN; //Green if correct
                end
                
                if (x > 19 && x < 25 && y > 25 && y < 54) //w
                begin
                    oled_data <= GREEN; //Green if correct
                end
                
                if (x > 24 && x < 34 && y > 49 && y < 54) //w
                begin
                    oled_data <= GREEN; //Green if correct
                end
                
                if (x > 33 && x < 39 && y > 10 && y < 54) //w
                begin
                    oled_data <= GREEN; //Green if correct
                end
                
                if (x > 48 && x < 54 && y > 10 && y < 54) //I
                begin
                    oled_data <= GREEN; //Green if correct
                end
                
                if (x > 63 && x < 69 && y > 10 && y < 54) //N
                begin
                    oled_data <= GREEN; //Green if correct
                end
                
                if (x > 67 && x < 80 && y > 10 && y < 16) //N
                begin
                    oled_data <= GREEN; //Green if correct
                end
                
                if (x > 79 && x < 85 && y > 10 && y < 54) //N
                begin
                    oled_data <= GREEN; //Green if correct
                end
                
            end
            else if (guess > secret_num)
            begin
                if (x > 5 && x < 13 && y > 10 && y < 54) //L
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 11 && x < 19 && y > 46 && y < 54) //L
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 25 && x < 31 && y > 10 && y < 54) //E
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 30 && x < 38 && y > 10 && y < 18) //E
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 30 && x < 38 && y > 28 && y < 36) //E
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 30 && x < 38 && y > 46 && y < 54) //E
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 46 && x < 52 && y > 10 && y < 35) //S
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 49 && x < 60 && y > 10 && y < 18) //S
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 49 && x < 60 && y > 27 && y < 35) //S
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 54 && x < 60 && y > 33 && y < 54) //S
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 46 && x < 60 && y > 46 && y < 54) //S
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 68 && x < 74 && y > 10 && y < 35) //S1
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 71 && x < 82 && y > 10 && y < 18) //S1
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 69 && x < 82 && y > 27 && y < 35) //S1
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 76 && x < 82 && y > 33 && y < 54) //S1
                begin
                    oled_data <= RED; //RED if too high
                end
                
                if (x > 68 && x < 82 && y > 46 && y < 54) //S1
                begin
                    oled_data <= RED; //RED if too high
                end
            end
            else
            begin
                if (x > 0 && x < 7 && y > 10 && y < 54) //M
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 5 && x < 34 && y > 10 && y < 18) //M
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 14 && x < 21 && y > 10 && y < 54) //M
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 28 && x < 34 && y > 10 && y < 54) //M
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 37 && x < 45 && y > 10 && y < 54) //o
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 44 && x < 54 && y > 10 && y < 18) //o
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 44 && x < 54 && y > 46 && y < 54) //o
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 52 && x < 59 && y > 10 && y < 54) //o
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 62 && x < 69 && y > 10 && y < 54) //r
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 67 && x < 79 && y > 10 && y < 18) //r
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 83 && x < 89 && y > 10 && y < 54) //E
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 88 && x < 96 && y > 10 && y < 18) //E
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 88 && x < 96 && y > 28 && y < 36) //E
                begin
                    oled_data <= WHITE; //white if too low
                end
                
                if (x > 88 && x < 96 && y > 46 && y < 54) //E
                begin
                    oled_data <= WHITE; //white if too low
                end
            end
            
            x = x+1;
            y = y+1;
        end    
            
        else 
        begin
            oled_data = BLACK;
        end
        end
endmodule
