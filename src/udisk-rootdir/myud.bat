@echo off

title Myud
color 0f












pause>nul
exit 0


::+------------------------------------------------------------
::|     Function - �滻�ַ���
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
::|     Function - ��� sed �Ƿ����
::+------------------------------------------------------------

:checkSedExist

set sedPath=%cd%\GnuWin32\bin
set path=%sedPath%;%path%

sed --help>nul 2>nul

if not "%errorlevel%"=="0" (
        echo sed - û���ҵ�!
        pause>nul
        exit 1
)

goto:eof


::+------------------------------------------------------------
::|     Function - ����ļ��Ƿ����
::+------------------------------------------------------------

:checkFileExist

if not exist %~1 (
        echo �ļ������� - %cd%\%~1
        pause>nul
        exit 1
)

goto:eof
