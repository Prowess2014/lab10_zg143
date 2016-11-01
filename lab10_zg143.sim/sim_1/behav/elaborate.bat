@echo off
set xv_path=D:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto cb336912a46b4059a692205d90d5f6a8 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L xpm -L blk_mem_gen_v8_3_3 -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_uart_rx_behav xil_defaultlib.tb_uart_rx xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
