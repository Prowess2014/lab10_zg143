`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:37:23 10/06/2014 
// Design Name: 
// Module Name:    uart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module uart_rx(clk, reset, wren, rden, din, dout, rxin, addr);
input clk, reset, wren, rden;
input [7:0] din;
output [8:0] dout;
input rxin;       //serial data in
input [2:0] addr;

reg [8:0] dout;

parameter PERIOD = 8'h0C;  

`define PERIOD_REG  3'b100
`define RX_REG      3'b101
`define STATUS_REG  3'b111
// double DFFs
reg q, Rxin;
always @(posedge clk) begin
    q <= rxin;  
    Rxin <= q;
end
    
wire [7:0] Period_out, Status_out;
reg [7:0] Status_reg;
wire baud16x, baud_gen_en;
wire sreg_en, timer_en;
wire fifo_rden, fifo_wren, fifo_full, fifo_empty, fifo_sclr;       // fifo signals
wire [8:0] fifo_in, fifo_out;
wire stat_wren, preg_rden, stat_rden;
//assign stat_wren = ((addr == `STATUS_REG) && wren);
//assign stat_rden = ((addr == `STATUS_REG) && rden);
//assign preg_rden = ((addr == `PERIOD_REG) && rden);
//assign fifo_rden = ((addr == `RX_REG) && rden);
wire [3:0] bitcount, bit_clk;
wire bitclk_en, bitcount_en, bitclk_sclr, bitcount_sclr;
wire Rxen, DataRdy, OverRun;
assign Rxen = Status_reg[0]; 
assign DataRdy = !fifo_empty;
assign OverRun = Status_out[2];  
assign baud_gen_en = timer_en;
// Generate the basic Baud rate clk
baud_gen #(.PERIOD(PERIOD),.PERIOD_REG(`PERIOD_REG)) baudclk(
    .clk(clk),
    .reset(reset),
    .addr(addr),
    .rden(rden),
    .wren(wren),
    .timer_en(baud_gen_en),
    .din(din),
    .dout(Period_out),
    .baud16x(baud16x)
    );
// FSM Control
FSM_CTL UART_RX_FSM(
    .clk(clk),
    .reset(reset),
    .Rxen(Rxen),
    .Rxin(Rxin),
    .fifo_full(fifo_full),
    .baud16x(baud16x),
    .bit_clk(bit_clk),
    .bit_cnt(bitcount),
    .fifo_wren(fifo_wren),
    .fifo_sclr(fifo_sclr),
    .timer_en(timer_en),
    .bitclk_en(bitclk_en),
    .bitclk_sclr(bitclk_sclr),
    .bitcount_en(bitcount_en),
    .bitcount_sclr(bitcount_sclr),
    .sreg_en(sreg_en),
    .Sreg(Status_out));



////FIFO 9 bits

fifo RxFIFO(.clk(clk), 
            .reset(reset), 
            .sclr(fifo_sclr), 
            .wren(fifo_wren), 
            .rden(fifo_rden), 
            .full(fifo_full), 
            .empty(fifo_empty), 
            .din(fifo_in), 
            .dout(fifo_out));
            
    
// bit timer counter.     
FourBitCounter Bit_timer(
    .clk(clk),
    .reset(reset),
    .en(bitclk_en),
    .sclr(bitclk_sclr),     // The sclr might be optional
    .dout(bit_clk));
// bit counter, which counts how many bits have been processed. 
//assign bitcount_sclr = (bitcount == 'd10);      // sclr is critical, otherwise the bit_cnt won't wrap to 0
FourBitCounter Bit_counter(
    .clk(clk),
    .reset(reset),
    .en(bitcount_en),
    .sclr(bitcount_sclr),       
    .dout(bitcount));   
// Shift register.     
wire [9:0] shift_out;
wire error_bit;
assign error_bit = !((shift_out[9] == 1) && (shift_out[0] == 0));   // error = 0 when start=1, stop=0
assign fifo_in = {error_bit, shift_out[8:1]};
ShiftReg shift_reg(
    .clk(clk),
    .reset(reset),
    .en(sreg_en),
    .sclr(),
    .sdin(Rxin),
    .dout(shift_out));
    
reg [2:0] addrq;
reg rdenq;
always @(posedge clk or posedge reset) begin
    if(reset) begin 
        rdenq <= 0;
        addrq <= 0;
    end else begin       
        rdenq <= rden;
        addrq <= addr;
    end
end
assign stat_wren = ((addr == `STATUS_REG) && wren);
assign stat_rden = ((addr == `STATUS_REG) && rden);
assign preg_rden = ((addr == `PERIOD_REG) && rden);
assign fifo_rden = ((addr == `RX_REG) && rden);

always @(posedge clk or posedge reset) begin
    if(reset) begin 
        Status_reg <= 0;
        dout <= 0;
     end
    else begin       
        Status_reg[1] <= DataRdy;
        Status_reg[2] <= OverRun;
        if(stat_wren) Status_reg[0] <= din[0];        // clear TXDONE bit
        dout <= preg_rden? {0, Period_out} : (stat_rden ? {0,Status_reg} : fifo_out );
     end
end
        
        
endmodule
