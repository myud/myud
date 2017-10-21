::+------------------------------------------------------------
::      Batch - 更改U盘卷标
::
::      Usage: UDiskLabel "卷标"
::+------------------------------------------------------------
@echo off
color 0f
echo,%~n0 - Running...


rem start
set UDiskLabel_Name=%~n0
set UDiskLabel_Path=%~dp0

set UDiskLabelKeyname=HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR\Enum

set UDiskLabelArgument1=%~1

if not defined UDiskLabelArgument1 (
        call :exit "missing operand!"
)

for /f "tokens=1-3" %%a in ('reg query "%UDiskLabelKeyname%" /v Count 2^>nul') do (
        if /i "%%a"=="Count" (
                set /a UDiskLabelCountVar=%%c
        )
)

if /i "%UDiskLabelCountVar%"=="0" (
        call :exit "udisk not found!"
)

for /f "tokens=1-3" %%a in ('wmic logicaldisk get Description^,DeviceID^,VolumeName 2^>nul') do (
        if /i "%%a"=="可移动磁盘" (
                label %%b %UDiskLabelArgument1%
        )
)


rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof
