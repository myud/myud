@ECHO OFF

REM 初始化
title %~n0
color 0f

set MyudPath=%~dp0
set MyudPath=%MyudPath:~0,-1%

set MyudFunc=%MyudPath%\cmd\MyudFunc.cmd

choice /t 1 /d y /n>nul

if not exist %MyudFunc% (
        echo,%~n0 - Main Error: %MyudFunc% 文件不存在!
        pause>nul
        exit 1
)

call %MyudFunc% CheckUDisk "MYUD"

REM 交互
echo,
set /p Ipaddr=请输入你的 IP  (默认:192.168.1.5): 
if not defined Ipaddr (
        set Ipaddr=192.168.1.5
)

echo,
set /p Gateway=请输入你的网关 (默认:192.168.1.1): 
if not defined Gateway (
        set Gateway=192.168.1.1
)

echo,
set /p DNS=请输入你的 DNS (默认:114.114.114.114): 
if not defined DNS (
        set DNS=114.114.114.114
)

echo,
echo,请按任意键开始运行...

echo,
pause>nul

REM ###################################################
cls
echo,正在运行, 请稍后...

choice /t 1 /d y /n>nul

REM 结束
cls
echo,已完成, 请退出...

echo,
echo,你的  IP:        %Ipaddr%
echo,你的网关:        %Gateway%
echo,你的 DNS:        %DNS%

echo,
pause>nul

@GOTO:EOF


REM # Main Var
REM MyudPath
REM Ipaddr
REM Gateway
REM DNS
