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

set UDiskLabelArgument1=%~1

if not defined UDiskLabelArgument1 (
        call :exit "missing operand!"
)

for /f "tokens=1-3" %%a in ('wmic logicaldisk get Description^,DeviceID^,VolumeName 2^>nul') do (
        if /i "%%a"=="可移动磁盘" (
                label %%b %UDiskLabelArgument1%
        )
)

choice /t 1 /d y /n>nul


rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof
