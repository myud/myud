@ECHO OFF
REM ��ʼ��
title %~n0
color 0f

set MyudPath=%~dp0
set MyudPath=%MyudPath:~0,-1%

choice /t 1 /d y /n>nul

if not exist %MyudPath%\cmd\MyudFunc.cmd (
        echo,%~n0 - Main Error: %MyudPath%\cmd\MyudFunc.cmd �ļ�������!
        pause>nul
        exit 1
)




















REM ����
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

echo,
echo,�밴�������ʼ����...

echo,
pause>nul


REM 
cls
echo,��������, ���Ժ�...

choice /t 1 /d y /n>nul






REM ����
cls
echo,�����, ���˳�...

echo,
echo,���  IP:        %Ipaddr%
echo,�������:        %Gateway%
echo,��� DNS:        %DNS%

echo,
pause>nul
@GOTO:EOF


:
REM   arg1: 
REM return: 
SETLOCAL

:BEGIN

:END
(ENDLOCAL
        
)
GOTO:EOF


REM # Main Var
REM MyudPath
REM Ipaddr
REM Gateway
REM DNS
