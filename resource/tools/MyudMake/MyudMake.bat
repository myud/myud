:::::::: Main ::::::::

@echo off
title %~n0
color 0f

set SelfPath=%~dp0
set SelfPath=%SelfPath:~0,-1%


:::::::: End ::::::::

pause>nul
exit 0

goto:eof


:::::::: Label ::::::::

:::: exit "message"
:exit

echo,%~n0 - Error: %~1
pause>nul
exit 1

goto:eof
