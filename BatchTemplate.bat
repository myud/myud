::+------------------------------------------------------------
::      Batch - 
::
::      Usage: 
::+------------------------------------------------------------
@echo off
color 0f
echo,%~n0 - Running...


rem start
set _Name=%~n0
set _Path=%~dp0

echo,高手
pause>nul



rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof
