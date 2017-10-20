::+------------------------------------------------------------
::      Batch - 检查命令
::
::      Usage: GnuWin32
::+------------------------------------------------------------
@echo off
color 0f
echo,%~n0 - Running...


rem start
set GnuWin32_Name=%~n0
set GnuWin32_Path=%~dp0

set GnuWin32Command01=7za
set GnuWin32Command02=awk
set GnuWin32Command03=dos2unix
set GnuWin32Command04=grep
set GnuWin32Command05=iconv
set GnuWin32Command06=md5
set GnuWin32Command07=sed
set GnuWin32Command08=wget

set path=%GnuWin32_Path%%GnuWin32Command08%\bin;%GnuWin32_Path%%GnuWin32Command07%\bin;%GnuWin32_Path%%GnuWin32Command06%\bin;%GnuWin32_Path%%GnuWin32Command05%\bin;%GnuWin32_Path%%GnuWin32Command04%\bin;%GnuWin32_Path%%GnuWin32Command03%\bin;%GnuWin32_Path%%GnuWin32Command02%\bin;%GnuWin32_Path%%GnuWin32Command01%\bin;%path%

set GnuWin32CommandList=%GnuWin32Command08%,%GnuWin32Command07%,%GnuWin32Command06%,%GnuWin32Command05%,%GnuWin32Command04%,%GnuWin32Command03%,%GnuWin32Command02%,%GnuWin32Command01%

for %%a in (%GnuWin32CommandList%) do (
        %%a --help>nul 2>nul||call :exit "%%a command not found!"
)

choice /t 2 /d y /n>nul


rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof
