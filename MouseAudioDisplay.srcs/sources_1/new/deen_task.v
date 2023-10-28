`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2023 12:18:43 PM
// Design Name: 
// Module Name: deen_task
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

module deen_task(
    input clock,
    input [11:0] sample,        // this is sample in 
//    output reg sound_heard = 0,          // most impt
    input enable,
    output [8:0] dtask_led,
    output dtask_an,        // an[0]
    output [6:0] dtask_seg
    );
    

    
    wire clock20khz;
    d_flexible_clock (clock, 2499, clock20khz);
    
    reg [31:0] count = 0;
    reg [4:0] peak_intensity = 0;
    
    reg [8:0] dt_led;
    assign dtask_led = dt_led;
    reg dt_an;
    assign dtask_an = dt_an;
    reg [6:0] dt_seg;
    assign dtask_seg = dt_seg;

    reg [11:0] max = 0;

    always @ (posedge clock20khz) 
    begin
        if (enable == 1)
        begin
            dt_an <= 1'b0;      // on an0
            count <= (count == 1999) ? 0 : count + 1;       // reset
            max <= count == 0 ? sample : (sample > max ? sample : max);
            if (count == 0) 
            begin
                peak_intensity = max[10:6];
                if (peak_intensity >= 5'd0 && peak_intensity <= 5'd2) 
                begin
                    dt_led <= 9'b000000000;   // 0
                    dt_seg <= 7'b1000000; // 0
                end
                else if (peak_intensity >= 5'd3 && peak_intensity <= 5'd5) 
                begin
                    dt_led <= 9'b000000001;   // 1
                    dt_seg <= 7'b1111001; // 1
                end
                else if (peak_intensity >= 5'd6 && peak_intensity <= 5'd8) 
                begin
                    dt_led <= 9'b000000011;   // 2
                    dt_seg <= 7'b0100100; // 2  
                end
                else if (peak_intensity >= 5'd9 && peak_intensity <= 5'd11) 
                begin
                    dt_led <= 9'b000000111;   // 3
                    dt_seg <= 7'b0110000; // 3  
                end
                else if (peak_intensity >= 5'd12 && peak_intensity <= 5'd14) 
                begin                                                 
                    dt_led <= 9'b000001111;   // 4                
                    dt_seg <= 7'b0011001; // 4                            
                end                                                   
                else if (peak_intensity >= 5'd16 && peak_intensity <= 5'd17) 
                begin                                                 
                    dt_led <= 9'b000011111;   // 5                
                    dt_seg <= 7'b0010010; // 5                            
                end                                                   
                else if (peak_intensity >= 5'd18 && peak_intensity <= 5'd20) 
                begin                                                 
                    dt_led <= 9'b000111111;   // 6               
                    dt_seg <= 7'b0000010; // 6                            
                end                                                   
                else if (peak_intensity >= 5'd21 && peak_intensity <= 5'd23) 
                begin                                                 
                    dt_led <= 9'b001111111;   // 7                
                    dt_seg <= 7'b1111000; // 7                            
                end                                                   
                else if (peak_intensity >= 5'd24 && peak_intensity <= 5'd27) 
                begin                                                 
                    dt_led <= 9'b011111111;   // 8                
                    dt_seg <= 7'b0000000; // 8                            
                end                                                   
                else if (peak_intensity >= 5'd28 && peak_intensity <= 5'd31) 
                begin
                    dt_led <= 9'b111111111;   // 9
                    dt_seg <= 7'b0010000; // 9
                end
//                else if (peak_intensity >= 4'd29 && peak_intensity <= 4'd32) 
//                begin
//                    sound_heard <= 1;
//                end                                                                                
            end
        end
        
        else if (enable == 0)
        begin
            dt_an <= 1'b1;
            dt_led <= 9'b000000000;
        end
    
    end
endmodule
