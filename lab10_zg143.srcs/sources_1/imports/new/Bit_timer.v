`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2016 11:52:30 PM
// Design Name: 
// Module Name: Bit_timer
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


module FourBitCounter(
    input clk,
    input reset,
    input en,
    input sclr,
    output reg [3:0] dout
    );
//wire sclr;
//assign sclr = (dout == 4'b1111);        
always @(posedge clk or posedge reset) begin
    if(reset) dout <= 0;
    else begin
        if(en) dout <= dout + 1'b1;
        if(sclr) dout <= 0;
    end
end     

endmodule
