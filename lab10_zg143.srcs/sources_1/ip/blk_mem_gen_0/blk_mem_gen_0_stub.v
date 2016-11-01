// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
// Date        : Sun Oct 30 23:46:12 2016
// Host        : GONG-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {e:/Documents/OneDrive/MSUStudy/Courses/2016Fall_Digital System
//               Design/lab10/lab10_zg143/lab10_zg143.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_stub.v}
// Design      : blk_mem_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_3,Vivado 2016.2" *)
module blk_mem_gen_0(clka, ena, wea, addra, dina, douta, clkb, enb, web, addrb, dinb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[2:0],dina[8:0],douta[8:0],clkb,enb,web[0:0],addrb[2:0],dinb[8:0],doutb[8:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [2:0]addra;
  input [8:0]dina;
  output [8:0]douta;
  input clkb;
  input enb;
  input [0:0]web;
  input [2:0]addrb;
  input [8:0]dinb;
  output [8:0]doutb;
endmodule
