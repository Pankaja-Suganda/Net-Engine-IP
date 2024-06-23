@echo off
REM ****************************************************************************
REM Vivado (TM) v2023.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : AMD Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Sun Jun 23 08:08:09 +0530 2024
REM SW Build 4029153 on Fri Oct 13 20:14:34 MDT 2023
REM
REM Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
REM Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim net_engine_v1_0_tb_behav -key {Behavioral:sim_1:Functional:net_engine_v1_0_tb} -tclbatch net_engine_v1_0_tb.tcl -view D:/Vivado/Project/net_engine_ip/net_engine_v1_0_tb_behav.wcfg -log simulate.log"
call xsim  net_engine_v1_0_tb_behav -key {Behavioral:sim_1:Functional:net_engine_v1_0_tb} -tclbatch net_engine_v1_0_tb.tcl -view D:/Vivado/Project/net_engine_ip/net_engine_v1_0_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
