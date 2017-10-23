:::::::: Main Start ::::::::


::::  S
@echo off
title %~n0
color 0f

set SelfPath=%~dp0
set SelfPath=%SelfPath:~0,-1%


::::  初始化
call :init


::::  交互
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


::::  E
pause>nul
exit 0


:::::::: Main End ::::::::
goto:eof




:::::::: Label Start ::::::::


::::  exit  "message"
:exit

echo,%~n0 - Error: %~1
pause>nul
exit 1

goto:eof


::::  init
:init

set Command1=7za
set Command2=awk
set Command3=dos2unix
set Command4=grep
set Command5=iconv
set Command6=md5
set Command7=sed
set Command8=wget

set path=%SelfPath%\%Command8%\bin;%SelfPath%\%Command7%\bin;%SelfPath%\%Command6%\bin;%SelfPath%\%Command5%\bin;%SelfPath%\%Command4%\bin;%SelfPath%\%Command3%\bin;%SelfPath%\%Command2%\bin;%SelfPath%\%Command1%\bin;%path%

set CommandList=%Command8%,%Command7%,%Command6%,%Command5%,%Command4%,%Command3%,%Command2%,%Command1%

for %%a in (%CommandList%) do (
        if not exist %SelfPath%\%%a\bin\%%a.exe (
                call :exit "%%a command not found!"
        )
        
        choice /t 1 /d y /n>nul
)

goto:eof


:::::::: Label End ::::::::
