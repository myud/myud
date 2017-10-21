::+------------------------------------------------------------
::      Batch - 
::
::      Usage: UDiskAttr
::+------------------------------------------------------------
@echo off
color 0f
echo,%~n0 - Running...


rem start
set UDiskAttr_Name=%~n0
set UDiskAttr_Path=%~dp0






rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof
