::+------------------------------------------------------------
::|     Batch - 检测 GnuWin32 命令
::+------------------------------------------------------------

:: 使用: call 绝对路径\GnuWin32.bat
:: 结果: 命令不可以执行就退出
:: 说明: 

@echo off

set GnuWin32Path=%~dp0

set GnuWin32Command01=7za
set GnuWin32Command02=awk
set GnuWin32Command03=dos2unix
set GnuWin32Command04=grep
set GnuWin32Command05=iconv
set GnuWin32Command06=md5
set GnuWin32Command07=sed
set GnuWin32Command08=wget

set path=%GnuWin32Path%%GnuWin32Command08%\bin;%GnuWin32Path%%GnuWin32Command07%\bin;%GnuWin32Path%%GnuWin32Command06%\bin;%GnuWin32Path%%GnuWin32Command05%\bin;%GnuWin32Path%%GnuWin32Command04%\bin;%GnuWin32Path%%GnuWin32Command03%\bin;%GnuWin32Path%%GnuWin32Command02%\bin;%GnuWin32Path%%GnuWin32Command01%\bin;%path%

set GnuWin32CommandList=%GnuWin32Command08%,%GnuWin32Command07%,%GnuWin32Command06%,%GnuWin32Command05%,%GnuWin32Command04%,%GnuWin32Command03%,%GnuWin32Command02%,%GnuWin32Command01%

for %%a in (%GnuWin32CommandList%) do (
        %%a --help>nul 2>nul||set GnuWin32Command=%%a
)

if defined GnuWin32Command (
        echo,%GnuWin32Command% - Command not found!
        pause>nul
        exit 1
)

goto :eof
