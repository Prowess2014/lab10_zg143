`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module fifo(clk, reset, sclr, wren, rden, full, empty, din, dout );
input clk, reset, sclr, wren, rden;
input [8:0] din;
output full, empty;
output [8:0] dout;
parameter FIFO_SIZE = 'd8;

reg [2:0] head, tail;
wire fifo_write, fifo_read;
assign fifo_write = wren && (!full);
assign fifo_read = rden && (!empty);
assign empty = (head == tail);
assign full  = (tail == (head + 1'b1));

always @(posedge clk or posedge reset) begin
    if(reset) begin
        head <= 0;
        tail <= 0;
    end else begin
        if(sclr) begin
            head <= 0;
            tail <= 0;
        end
        if(fifo_read) tail <= tail + 1'b1;
        if(fifo_write) head <=  head + 1'b1;  
    end
end

blk_mem_gen_0 mem_zg143(.clka(clk), 
              .ena(1), 
              .wea(fifo_write), 
              .addra(head), 
              .dina(din), 
              .douta(), 
              .clkb(clk), 
              .enb(fifo_read), 
              .web(0), 
              .addrb(tail), 
              .dinb(), 
              .doutb(dout));
endmodule
