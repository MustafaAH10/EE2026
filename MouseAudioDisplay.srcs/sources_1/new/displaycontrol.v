module displaycontrol(
input CLOCK, input clock20khz, input sample, input trigger, input [9:0] is, 
output reg [3:0] an1 , output reg [6:0]seg1 , output reg dp1, output reg [8:0] led = 0
    );
    wire clock10khz;
    reg  count = 0;
    clock10k clock10k (CLOCK, clock10khz);
    
//    reg [31:0] audio_count = 0;
    reg [11:0] peak_intensity = 0;
    wire clk20khz;
    assign clk20khz = clock20khz;
    
    reg [3:0] an = 4'b1111;
    reg [6:0] seg = 7'b1111111;
    reg dp = 1'b1;
    
    
    
 
    
    always @ (posedge CLOCK)
    begin
    
         an1 <= an;
         seg1 <= seg;
         dp1 <= dp;
    
        if (count == 30)
        begin
            count <= 0;
        end
        else 
        begin
            count <= count + 1;
        end
    end
    
    always @ (posedge CLOCK)
    begin
    
   
            if (count == 0 && trigger == 1)
            begin
            if (is[0] || is[1] || is[2] || is[3] || is[4] || is[5] || is[6] || is[7] || is[8])
                begin
                    an[3:2] <= 2'b01;
                    seg[6:0] <= 7'b1000000;     // 0
                    dp <= 1'b0;
                end
            else if (is[9]) 
                begin
                    an[3:2] <= 2'b01;
                    seg[6:0] <= 7'b1111001;     // 1
                    dp <= 1'b0;
                end
            else
                begin
                    seg[6:0] = 7'b1111111;
                    dp <= 1'b1;
                    an[3:0] = 4'b1111;
                end
            end
            
            else if (count == 1 && trigger == 1)
            begin
                if (is[0])
                begin
                    an[3:2] <= 2'b10;
                    seg[6:0] <= 7'b1111001;
                    dp <= 1'b1;
                end
                else if (is[1])
                begin
                    an[3:2] <= 2'b10;
                    seg[6:0] <= 7'b0100100;
                    dp <= 1'b1;
                end
                else if (is[2])
                begin
                    an[3:2] <= 2'b10;
                    seg[6:0] <= 7'b0110000;
                    dp <= 1'b1;
                end
                else if (is[3])
                begin
                    an[3:2] <= 2'b10;
                    seg[6:0] <= 7'b0011001;
                    dp <= 1'b1;
                end
                else if (is[4])
                begin
                    an[3:2] <= 2'b10;
                    seg[6:0] <= 7'b0010010;
                    dp <= 1'b1;
                end
                else if (is[5])
                begin
                    an[3:2] <= 2'b10;
                    seg[6:0] <= 7'b0000010;
                    dp <= 1'b1;
                end
                else if (is[6])
                begin
                    an[3:2] <= 2'b10;
                    seg[6:0] <= 7'b1111000;
                    dp <= 1'b1;
                end
                else if (is[7])
                begin
                    an[3:2] <= 2'b10;
                    seg[6:0] <= 7'b0000000;
                    dp <= 1'b1;
                end
                else if (is[8])
                begin
                    an[3:2] <= 2'b10;
                    seg[6:0] <= 7'b0011000;
                    dp <= 1'b1;
                end
                else if (is[9])
                begin
                    an[3:2] <= 2'b10;
                    seg[6:0] <= 7'b1000000;
                    dp <= 1'b1;
                end
                else
                begin
                    seg[6:0] = 7'b1111111;
                    dp = 1'b1;
                    an[3:0] = 4'b1111;
                end
            
            
            
            end
            
  
            
            else begin
            
                 led <= 9'b111111111;   // 9
                   seg <= 7'b1111111; // 9
                   an <= 4'b1111;
            
            
            end
            
           
        
       
    end
    
endmodule
