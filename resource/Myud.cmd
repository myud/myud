:::: 初始化
@echo off
title %~n0
color 0f

set SelfPath=%~dp0
set SelfPath=%SelfPath:~0,-1%

choice /t 1 /d y /n>nul

call :checkUDisk "MYUD"

call :checkCommand











:::: 交互
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
        call :exit "checkUDisk: 缺少参数!"
)

for /f "tokens=1-3" %%a in ('reg query "%CheckUDiskKeyname%" /v Count 2^>nul') do (
        if /i "%%a"=="Count" (
                set /a CheckUDiskCountVar=%%c
        )
)

if /i "%CheckUDiskCountVar%"=="0" (
        rem call :exit "udisk not found!"
        call :exit "U盘不存在!"
)

for /f "tokens=1-3" %%a in ('wmic logicaldisk get Description^,DeviceID^,VolumeName 2^>nul') do (
        if /i "%%a"=="可移动磁盘" (
                if /i "%%b"=="%SelfPath%" (
                        set CheckUDiskDeviceID=%%b
                        set CheckUDiskVolumeName=%%c
                )
        )
)

if not defined CheckUDiskDeviceID (
        call :exit "请将此程序复制到U盘根目录下运行!"
)

if /i not "%CheckUDiskVolumeName:~0,4%"=="MYUD" (
        label %CheckUDiskDeviceID% %CheckUDiskArgument1%
)

goto:eof


:::: checkCommand
:checkCommand

set CheckCommand1=7za
set CheckCommand2=awk
set CheckCommand3=dos2unix
set CheckCommand4=grep
set CheckCommand5=iconv
set CheckCommand6=md5
set CheckCommand7=sed
set CheckCommand8=wget

set path=%SelfPath%\cmd\%CheckCommand8%\bin;%SelfPath%\cmd\%CheckCommand7%\bin;%SelfPath%\cmd\%CheckCommand6%\bin;%SelfPath%\cmd\%CheckCommand5%\bin;%SelfPath%\cmd\%CheckCommand4%\bin;%SelfPath%\cmd\%CheckCommand3%\bin;%SelfPath%\cmd\%CheckCommand2%\bin;%SelfPath%\cmd\%CheckCommand1%\bin;%path%

set CheckCommandList=%CheckCommand8%,%CheckCommand7%,%CheckCommand6%,%CheckCommand5%,%CheckCommand4%,%CheckCommand3%,%CheckCommand2%,%CheckCommand1%

for %%a in (%CheckCommandList%) do (
        if not exist %SelfPath%\cmd\%%a\bin\%%a.exe (
                rem call :exit "%%a command not found!"
                call :exit "%%a 命令不存在!"
        )
)

goto:eof
