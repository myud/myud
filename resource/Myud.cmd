:::: ��ʼ��
@echo off
title %~n0
color 0f

set SelfPath=%~dp0
set SelfPath=%SelfPath:~0,-1%

choice /t 1 /d y /n>nul

call :checkUDisk "MYUD"













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


:::: checkUDisk "label"
:checkUDisk

set CheckUDiskKeyname=HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR\Enum

set CheckUDiskArgument1=%~1

if not defined CheckUDiskArgument1 (
        rem call :exit "checkUDisk: missing operand!"
        call :exit "checkUDisk: ȱ�ٲ���!"
)

for /f "tokens=1-3" %%a in ('reg query "%CheckUDiskKeyname%" /v Count 2^>nul') do (
        if /i "%%a"=="Count" (
                set /a CheckUDiskCountVar=%%c
        )
)

if /i "%CheckUDiskCountVar%"=="0" (
        rem call :exit "udisk not found!"
        call :exit "U�̲�����!"
)

for /f "tokens=1-3" %%a in ('wmic logicaldisk get Description^,DeviceID^,VolumeName 2^>nul') do (
        if /i "%%a"=="���ƶ�����" (
                if /i "%%b"=="%SelfPath%" (
                        set CheckUDiskDeviceID=%%b
                        set CheckUDiskVolumeName=%%c
                )
        )
)

if not defined CheckUDiskDeviceID (
        call :exit "�뽫�˳����Ƶ�U�̸�Ŀ¼������!"
)

if /i not "%CheckUDiskVolumeName:~0,4%"=="MYUD" (
        label %CheckUDiskDeviceID% %CheckUDiskArgument1%
)

goto:eof
