@echo off

title Myud
color 0f


::
set file1=.ks.cfg.bak
set file2=.ks.cfg.tmp

set file3=manual-install\.config-network.bak
set file4=manual-install\.config-network.tmp

call :checkFileExist "%file1%"
copy /y %file1% ks.cfg >nul

call :checkFileExist "%file3%"
copy /y %file3% manual-install\config-network >nul


::
echo/
set /p ipaddr= ��������� IP (Ĭ��:192.168.1.5): 

echo/
set /p gateway= ������������� (Ĭ��:192.168.1.1): 

echo/
set /p dns= ��������� DNS (Ĭ��:114.114.114.114): 
echo/

if not defined ipaddr (set ipaddr=192.168.1.5)
if not defined gateway (set gateway=192.168.1.1)
if not defined dns (set dns=114.114.114.114)


::
call :replaceStr "ks.cfg" "##custom##192.168.1.5##" "%ipaddr%" "%file2%"
call :replaceStr "ks.cfg" "##custom##192.168.1.1##" "%gateway%" "%file2%"
call :replaceStr "ks.cfg" "##custom##114.114.114.114##" "%dns%" "%file2%"

call :replaceStr "manual-install\config-network" "##custom##192.168.1.5##" "%ipaddr%" "%file4%"
call :replaceStr "manual-install\config-network" "##custom##192.168.1.1##" "%gateway%" "%file4%"
call :replaceStr "manual-install\config-network" "##custom##114.114.114.114##" "%dns%" "%file4%"


::
cls
color 0a
echo +--------------------------------------------------
echo ^|
echo ^|            ���óɹ�
echo ^|
echo +--------------------------------------------------

echo/
echo ��� IP:     %ipaddr%
echo �������:    %gateway%
echo ��� DNS:    %dns%
echo/

pause>nul
exit 0


:: --------------------------------------------------
:: Function - ����ļ��Ƿ����
:: --------------------------------------------------

:checkFileExist

if not exist %~1 (
        echo ����: '%cd%\%~1' �ļ�������
        pause>nul
        exit 1
)

goto:eof


:: --------------------------------------------------
:: Function - �滻�ַ���
:: --------------------------------------------------

:replaceStr
setlocal enabledelayedexpansion

set filename=%~1
set oldstr=%~2
set newstr=%~3
set tmpfile=%~4

call :checkFileExist "%filename%"

if exist %tmpfile% (
        del /f %tmpfile%
)

for /f "tokens=1* delims=:" %%a in ('findstr /n .* %filename%') do (
        set var=%%b
        set myvar=!var:%oldstr%=%newstr%!
        set tmpvar=!var: =!
        
        if defined var (
                
                if not "!tmpvar!"=="" (
                        echo !myvar!>>%tmpfile%
                ) else (
                        echo/!var!>>%tmpfile%
                )
                
        ) else (
                echo/>>%tmpfile%
        )
)

move /y %tmpfile% %filename% >nul

endlocal
goto:eof
