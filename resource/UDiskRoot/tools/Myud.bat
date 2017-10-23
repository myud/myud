:: Main Program


@echo off
color 0f

title Myud


rem start
set Myud_Name=%~n0
set Myud_Path=%~dp0

set MyudBatchList=MyudCaw.bat,MyudDownload.bat,ReplaceStr.bat,UDiskAttr.bat,UDiskLabel.bat

if exist %Myud_Path%GnuWin32\GnuWin32.bat (
        call %Myud_Path%GnuWin32\GnuWin32.bat
) else (
        call :exit "GnuWin32.bat not found!"
)

for %%a in (%MyudBatchList%) do (
        if not exist %Myud_Path%%%a (
                call :exit "%%a not found!"
        )
)


:: 



























rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof










