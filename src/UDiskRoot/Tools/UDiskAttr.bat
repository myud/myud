::+------------------------------------------------------------
::      Batch - 获取U盘属性
::
::      Usage: UDiskAttr "目录"
::+------------------------------------------------------------
@echo off
color 0f
echo,%~n0 - Running...


rem start
set UDiskAttr_Name=%~n0
set UDiskAttr_Path=%~dp0

set UDiskAttrKeyname=HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR\Enum

set UDiskAttrArgument1=%~1

if not defined UDiskAttrArgument1 (
        call :exit "missing operand!"
)

if /i "%UDiskAttrArgument1:~0,1%"=="\" (
        set UDiskAttrArgument1=%UDiskAttrArgument1:~1%
)

echo,%UDiskAttrArgument1%|findstr /i "^[c-z]:\\\\">nul 2>nul||set UDiskAttrArgument1=%cd%\%UDiskAttrArgument1%

if /i "%UDiskAttrArgument1:~-1%"=="\" (
        if /i not "%UDiskAttrArgument1:~-2%"==":\" (
                set UDiskAttrArgument1=%UDiskAttrArgument1:~0,-1%
        )
)

for /f "tokens=1-3" %%a in ('reg query "%UDiskAttrKeyname%" /v Count 2^>nul') do (
        if /i "%%a"=="Count" (
                set /a UDiskAttrCountVar=%%c
        )
)

if /i "%UDiskAttrCountVar%"=="0" (
        call :exit "udisk not found!"
)

if not exist %UDiskAttrArgument1% (
        mkdir %UDiskAttrArgument1%
)

for /l %%a in (0,1,%UDiskAttrCountVar%) do (
        set /a UDiskAttrNum=%%a-1
        
        setlocal enabledelayedexpansion
        
        for /f "tokens=1-3" %%b in ('reg query "%UDiskAttrKeyname%" 2^>nul') do (
                if /i "%%b"=="!UDiskAttrNum!" (
                        
                        set USBAttr=%%d
                        set USBVID=!USBAttr:~8,4!
                        set USBPID=!USBAttr:~17,4!
                        set USBSN=!USBAttr:~22!
                        
                        echo,VID: !USBVID! PID: !USBPID! SN: !USBSN!>%UDiskAttrArgument1%\UDiskAttr_!USBSN!.txt
                        
                )
        )
        
        endlocal
)


rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof
