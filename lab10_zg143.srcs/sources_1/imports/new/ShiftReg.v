`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2016 10:44:50 AM
// Design Name: 
// Module Name: baudclk
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


module ShiftReg(
    input clk,
    input reset,
    input en,
    //input ld,
    input sclr,
    input sdin,
    output [9:0]dout);
reg [9:0] dout;    
always @(posedge clk or posedge reset) begin
    if(reset) dout<=0;
    else begin
        if(en) dout <= {sdin, dout[9:1]};

        //if(ld) q <= din;
        if(sclr) dout <= 0;
    end
end

//assign dout = q;
    
endmodule
