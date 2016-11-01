`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2016 11:12:21 PM
// Design Name: 
// Module Name: baud_gen
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


module baud_gen(
    input clk,
    input reset,
    input [2:0] addr,
    input rden,
    input wren,
    input timer_en,
    input [7:0] din,
    output [7:0] dout,
    output baud16x
    );
    
parameter PERIOD = 8'h1A;  
parameter PERIOD_REG = 3'b000;
  
wire Period_reg_en;    // 3 reg addr enable signals
wire timer_match; 
reg baud16x;
reg [7:0] Timer_reg;
reg [7:0] Period_reg;  
assign Period_reg_en = (addr == PERIOD_REG);
assign timer_match = (Period_reg == Timer_reg);
assign timer_en = 1;
always @(posedge timer_match or posedge reset) begin
    if(reset)baud16x <= 0;
    else baud16x <= ~baud16x;
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        Timer_reg <= 0;
        Period_reg <= PERIOD;
    end else begin
        if(timer_en) begin           
            if(wren && Period_reg_en) Period_reg <= din;   
            Timer_reg <= Timer_reg + 1'b1;
            if(Timer_reg >= Period_reg) Timer_reg <= 0;
        end
    end
end      
assign dout = (Period_reg_en && rden)? Period_reg : 0;    
    
endmodule
