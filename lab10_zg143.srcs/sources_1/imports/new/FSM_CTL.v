`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2016 11:25:58 PM
// Design Name: 
// Module Name: FSM_CTL
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


module FSM_CTL(
    input clk,
    input reset,
    input Rxen,
    input Rxin,
    //input stat_wren,
    //input fifo_empty,
    input fifo_full,
    input baud16x,
    input [3:0] bit_clk,
    input [3:0] bit_cnt,
    output reg fifo_wren,
    output reg fifo_sclr,
    output reg timer_en,
    output reg bitclk_en,
    output reg bitclk_sclr,
    output reg bitcount_en,
    output reg bitcount_sclr,
    //output reg sreg_ld,
    output reg sreg_en,
    output reg [7:0] Sreg
    );
`define WAIT        2'b00
`define SHIFT1      2'b01
`define SHIFT2      2'b10
`define OVERRUN     2'b11    

reg [1:0] pstate, nstate;       // FSM 
//reg sreg_ld, sreg_en, fifo_rden;
//reg [7:0] Sreg;
reg DataRdy, OverRun;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        Sreg <= 0;
        //fifo_rden <= 0;
        bitclk_sclr <= 1;
        bitcount_sclr <= 1;
        OverRun <= 0;
        pstate <= `WAIT;
    end
    else begin
        pstate <= nstate;
        Sreg[0] <= Rxen;
        Sreg[1] <= DataRdy;  
        Sreg[2] <= OverRun;  
    end
end

always @* begin
    //initialze
    fifo_wren = 0;
    fifo_sclr = 0;
    bitclk_en = 0;
    bitcount_en = 0;
    bitclk_sclr = 0;
    bitcount_sclr = 0;   
    sreg_en = 0;
    nstate = pstate;
    DataRdy = 1'b0;
    timer_en = 1'b0;
    case (pstate)
        `WAIT: begin
            if(Rxen) begin
                //fifo_rden = 1;
                //bitcount_sclr = 1;      
                if(!Rxin) nstate = `SHIFT1;
           end
        end
        `SHIFT1: begin
            timer_en = 1;
            if(bit_cnt == 'd10) begin       // Note that the width of bit_cnt must match with input    
                if(fifo_full) nstate = `OVERRUN;
                else begin
                    DataRdy = 1;
                    fifo_wren = 1;
                    bitcount_sclr = 1;
                    nstate = `WAIT;   // return to WAIT state at falling edge
                end
            end 
            if(baud16x) begin
                bitclk_en = 1;
                nstate = `SHIFT2;
            end
        end
        `SHIFT2: begin
            timer_en = 1;
            if(!baud16x) begin    
                if(bit_clk == 'd0) begin
                    bitcount_en = 1;
                end
                if(bit_clk == 'd8) sreg_en = 1;
                nstate = `SHIFT1;
            end
        end
        `OVERRUN: begin
            OverRun = 1;
            if(!Rxen) begin
                OverRun = 0;
                fifo_sclr = 1;      // clear fifo
                nstate = `WAIT;
            end
        end
    endcase            
end

    
    
endmodule
