`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2016 07:36:57 PM
// Design Name: 
// Module Name: Output_Mux
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


module Output_Mux(
    input clk,
    input reset,
    input rden,
    input [2:0] addr,
    input [7:0] Period_reg,
    input [7:0] Status_reg,
    input [8:0] FIFO_out,
    output [8:0] dout
    );
reg [8:0] dout;    
    
    
    
    
endmodule
