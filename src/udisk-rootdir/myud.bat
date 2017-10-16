@echo off

title Myud
color 0f


::+------------------------------------------------------------
::|     �û�
::+------------------------------------------------------------

:: ��������
echo/
set /p ipaddr= ��������� IP  (Ĭ��:192.168.1.5): 

echo/
set /p gateway= ������������� (Ĭ��:192.168.1.1): 

echo/
set /p dns= ��������� DNS (Ĭ��:114.114.114.114): 

if not defined ipaddr (set ipaddr=192.168.1.5)
if not defined gateway (set gateway=192.168.1.1)
if not defined dns (set dns=114.114.114.114)


::+------------------------------------------------------------
::|     ����
::+------------------------------------------------------------

cls
echo ��������, ���Ժ�...

:: �滻�ļ�����
set file1=.ks.cfg.bak
set file2=ks.cfg
set file3=manual-install\.config-network.bak
set file4=manual-install\config-network

call :checkFileExist "%file1%"
copy /y %file1% %file2% >nul
call :checkFileExist "%file3%"
copy /y %file3% %file4% >nul

call :replaceStr "%file2%" "##custom##192\.168\.1\.5##" "%ipaddr%"
call :replaceStr "%file2%" "##custom##192\.168\.1\.1##" "%gateway%"
call :replaceStr "%file2%" "##custom##114\.114\.114\.114##" "%dns%"

call :replaceStr "%file4%" "##custom##192\.168\.1\.5##" "%ipaddr%"
call :replaceStr "%file4%" "##custom##192\.168\.1\.1##" "%gateway%"
call :replaceStr "%file4%" "##custom##114\.114\.114\.114##" "%dns%"


::+------------------------------------------------------------
::|     ����
::+------------------------------------------------------------

cls
color 0a
echo +------------------------------------------------------------
echo ^|
echo ^|                          ���óɹ�
echo ^|
echo +------------------------------------------------------------

echo/
echo ��� IP:     %ipaddr%
echo �������:    %gateway%
echo ��� DNS:    %dns%

echo/
echo/
echo/
echo ���˳�...

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
::|     Function - ת���ļ�����
::+------------------------------------------------------------

:convertFile

set convertfn=%~1

call :checkSedExist
call :checkFileExist "%convertfn%"

iconv -f gbk -t utf-8 %convertfn% > %convertfn%.tmp

move /y %convertfn%.tmp %convertfn% >nul

goto:eof


::+------------------------------------------------------------
::|     Function - ��� sed �������Ƿ����
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

dos2unix --help>nul 2>nul

if not "%errorlevel%"=="0" (
        echo dos2unix - û���ҵ�!
        pause>nul
        exit 1
)

iconv --help>nul 2>nul

if not "%errorlevel%"=="0" (
        echo iconv - û���ҵ�!
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
