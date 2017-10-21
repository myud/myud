::+------------------------------------------------------------
::      Batch - 替换字符串
::
::      Usage: ReplaceStr "原字符串" "新字符串" "文件"
::       Note: 不会改变原来的文件编码
::+------------------------------------------------------------
@echo off
color 0f
echo,%~n0 - Running...


rem start
set ReplaceStr_Name=%~n0
set ReplaceStr_Path=%~dp0

if exist %ReplaceStr_Path%GnuWin32\GnuWin32.bat (
        call %ReplaceStr_Path%GnuWin32\GnuWin32.bat
) else (
        call :exit "GnuWin32.bat not found!"
)

set ReplaceStrArgument1=%~1
set ReplaceStrArgument2=%~2
set ReplaceStrArgument3=%~3

if not defined ReplaceStrArgument1 (
        call :exit "missing oldstr!"
)

if not defined ReplaceStrArgument2 (
        call :exit "missing newstr!"
)

if not defined ReplaceStrArgument3 (
        call :exit "missing filename!"
)

if /i "%ReplaceStrArgument3:~0,1%"=="\" (
        set ReplaceStrArgument3=%ReplaceStrArgument3:~1%
)

echo,%ReplaceStrArgument3%|findstr /i "^[c-z]:\\\\">nul 2>nul||set ReplaceStrArgument3=%cd%\%ReplaceStrArgument3%

if /i "%ReplaceStrArgument3:~-1%"=="\" (
        call :exit "filename error!"
)

if not exist %ReplaceStrArgument3% (
        call :exit "%ReplaceStrArgument3% not found!"
)

sed -i "s/%ReplaceStrArgument1%/%ReplaceStrArgument2%/g" %ReplaceStrArgument3%

dos2unix %ReplaceStrArgument3%>nul 2>nul

:: 当前目录下
for %%a in (sed*) do (
        echo,%%a|grep "^sed[a-z0-9]\{6\}$">nul 2>nul&&del /f %%a
)


rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof
