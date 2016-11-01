@echo off
set xv_path=D:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim tb_uart_rx_behav -key {Behavioral:sim_1:Functional:tb_uart_rx} -tclbatch tb_uart_rx.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
