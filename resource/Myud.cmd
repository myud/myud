:::: Start
@echo off
title %~n0
color 0f

set SelfPath=%~dp0
set SelfPath=%SelfPath:~0,-1%

















:::: ����
echo,
set /p Ipaddr=��������� IP  (Ĭ��:192.168.1.5): 
if not defined Ipaddr (
        set Ipaddr=192.168.1.5
)

echo,
set /p Gateway=������������� (Ĭ��:192.168.1.1): 
if not defined Gateway (
        set Gateway=192.168.1.1
)

echo,
set /p DNS=��������� DNS (Ĭ��:114.114.114.114): 
if not defined DNS (
        set DNS=114.114.114.114
)





















pause>nul
:::::::: Main End :::::::::::
goto:eof
:::::::: Label Start ::::::::
:::: exit "message"
:exit

echo,%~n0 - Error: %~1
pause>nul
exit 1

goto:eof
