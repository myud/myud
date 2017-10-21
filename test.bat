::+------------------------------------------------------------
::Batch-¼ì²éÃüÁî
::
::Usage:GnuWin32
::+------------------------------------------------------------
@echooff
color0f
echo,%~n0-Running...


remstart
setGnuWin32_Name=%~n0
setGnuWin32_Path=%~dp0

setGnuWin32Command01=7za
setGnuWin32Command02=awk
setGnuWin32Command03=dos2unix
setGnuWin32Command04=grep
setGnuWin32Command05=iconv
setGnuWin32Command06=md5
setGnuWin32Command07=sed
setGnuWin32Command08=wget

setpath=%GnuWin32_Path%%GnuWin32Command08%\bin;%GnuWin32_Path%%GnuWin32Command07%\bin;%GnuWin32_Path%%GnuWin32Command06%\bin;%GnuWin32_Path%%GnuWin32Command05%\bin;%GnuWin32_Path%%GnuWin32Command04%\bin;%GnuWin32_Path%%GnuWin32Command03%\bin;%GnuWin32_Path%%GnuWin32Command02%\bin;%GnuWin32_Path%%GnuWin32Command01%\bin;%path%

setGnuWin32CommandList=%GnuWin32Command08%,%GnuWin32Command07%,%GnuWin32Command06%,%GnuWin32Command05%,%GnuWin32Command04%,%GnuWin32Command03%,%GnuWin32Command02%,%GnuWin32Command01%

for%%ain(%GnuWin32CommandList%)do(
%%a--help>nul2>nul||call:exit"%%acommandnotfound!"
)

::choice/t1/dy/n>nul


remend
goto:eof


remlabel
:exit
echo,%~n0-Error:%~1
pause>nul
exit1
goto:eof
