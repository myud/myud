@echo off

title Myud
color 0f












pause>nul
exit 0


::+------------------------------------------------------------
::|     Function - 替换字符串
::+------------------------------------------------------------

:replaceStr

set filename=%~1
set oldstr=%~2
set newstr=%~3

call :checkSedExist
call :checkFileExist "%filename%"
call :checkFileExist "GnuWin32\bin\dos2unix.exe"

sed -i "s/%oldstr%/%newstr%/g" %filename%

dos2unix %filename% >nul 2>nul

setlocal enabledelayedexpansion

for %%a in (sed*) do (
        set tmpfn=%%a
        
        if "!tmpfn:~0,9!"=="!tmpfn:~-9!" (
                del /f !tmpfn!
        )
)

endlocal

goto:eof


::+------------------------------------------------------------
::|     Function - 检测 sed 是否存在
::+------------------------------------------------------------

:checkSedExist

set sedPath=%cd%\GnuWin32\bin
set path=%sedPath%;%path%

sed --help>nul 2>nul

if not "%errorlevel%"=="0" (
        echo sed - 没有找到!
        pause>nul
        exit 1
)

goto:eof


::+------------------------------------------------------------
::|     Function - 检查文件是否存在
::+------------------------------------------------------------

:checkFileExist

if not exist %~1 (
        echo 文件不存在 - %cd%\%~1
        pause>nul
        exit 1
)

goto:eof
