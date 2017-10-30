@ECHO OFF

REM ��ʼ��
title %~n0
color 0f

set MyudPath=%~dp0
set MyudPath=%MyudPath:~0,-1%

set MyudFunc=%MyudPath%\MyudFunc.cmd
set MenuNum=3

choice /t 1 /d y /n>nul

if not exist %MyudFunc% (
        echo,%~n0 - Main Error: %MyudFunc% �ļ�������!
        pause>nul
        exit 1
)

REM Usage: call %MyudFunc% ��ǩ���� "����1" "����2" "����3"

call %MyudFunc% CheckUDisk "MYUD"

call %MyudFunc% CheckCommand

REM ���� ��������������
cls&echo,(1/%MenuNum%) �������� CentOS ϵͳ:
echo,

echo,
set /p Ipaddr=���������  IP    (Ĭ��:192.168.1.5): 
if not defined Ipaddr (
        set Ipaddr=192.168.1.5
)

echo,
set /p Gateway=�������������    (Ĭ��:192.168.1.1): 
if not defined Gateway (
        set Gateway=192.168.1.1
)

echo,
set /p DNS=��������� DNS    (Ĭ��:114.114.114.114): 
if not defined DNS (
        set DNS=114.114.114.114
)

echo,
set /p RootPassword=������ root  ���� (Ĭ��:123456): 
if not defined RootPassword (
        set RootPassword=123456
)

echo,
set /p AdminPassword=������ admin ���� (Ĭ��:123456): 
if not defined AdminPassword (
        set AdminPassword=123456
)

REM ���� ����U��
cls&echo,(2/%MenuNum%) ���û�ر� Myud ����:
echo,

echo,
set /p MountUDisk=�Ƿ������Զ�����U�� [Y/N]: 

if /i "%MountUDisk%"=="Y" (
        echo,
        set /p Var=�������Ҫ���ص�U�� ^(֧�ֶ��U��^): 
        call %MyudFunc% UDiskAttr
)

REM ���� ����Ӳ��
cls&echo,(3/%MenuNum%) ���û�ر� Myud ����:
echo,

echo,
set /p MountDisk=�Ƿ����ù�����Ӳ�� [Y/N]: 

if /i "%MountDisk%"=="Y" (
        call %MyudFunc% InteractiveDisk
)

REM ���� ����
cls&echo,�������!
echo,

if /i "%MountUDisk%"=="Y" (
        if not exist %FuncPath%\UDiskAttr.tmp (
                call %MyudFunc% Error "Main" "%FuncPath%\UDiskAttr.tmp �ļ�������"
        )
)

if /i "%MountDisk%"=="Y" (
        if not exist %FuncPath%\InteractiveDisk.tmp (
                call %MyudFunc% Error "Main" "%FuncPath%\InteractiveDisk.tmp �ļ�������"
        )
)

echo,
echo,  ���  IP:        %Ipaddr%
echo,  �������:        %Gateway%
echo,  ��� DNS:        %DNS%
echo,root  ����:        %RootPassword%
echo,admin ����:        %AdminPassword%

if /i "%MountUDisk%"=="Y" (
        for /f "tokens=1-6" %%a in ('findstr .* %FuncPath%\UDiskAttr.tmp') do (
                echo,%%f
        )
)

if /i "%MountDisk%"=="Y" (
        for /f "tokens=1-4" %%a in ('findstr .* %FuncPath%\InteractiveDisk.tmp') do (
                if defined %%b (
                        echo,%%b %%d
                )
        )
)




















echo,
echo,�밴�������ʼ��װ...
echo,
pause>nul






REM 
cls&echo,���ڰ�װ ���Ժ�...
echo,








REM 
cls&echo,��װ���!
echo,

echo,
echo,�밴������˳�...
echo,
pause>nul





REM �����ļ�
cls
echo,��������, ���Ժ�...

call %MyudFunc% ChangeFile

REM ����
call %MyudFunc% DownloadISO

REM ����
cls
echo,�����, ���˳�...

echo,
echo,���  IP:        %Ipaddr%
echo,�������:        %Gateway%
echo,��� DNS:        %DNS%

echo,
pause>nul
exit 0

@GOTO:EOF


GOTO:EOF ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# Main Var
MyudPath
MyudFunc
Ipaddr
Gateway
DNS

# Func Var
FuncPath
FuncName
DirPath
CommandPath
