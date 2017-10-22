:: Main Program


@echo off
color 0f

title Myud


rem start
set Myud_Name=%~n0
set Myud_Path=%~dp0

set MyudBatchList=MyudCaw.bat,MyudDownload.bat,ReplaceStr.bat,UDiskAttr.bat,UDiskLabel.bat

if exist %Myud_Path%GnuWin32\GnuWin32.bat (
        call %Myud_Path%GnuWin32\GnuWin32.bat
) else (
        call :exit "GnuWin32.bat not found!"
)

for %%a in (%MyudBatchList%) do (
        if not exist %Myud_Path%%%a (
                call :exit "%%a not found!"
        )
)


:: �û�



























rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof
















































































































































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
::|     Function - ת���ļ�����
::+------------------------------------------------------------

:: ʹ��: call :convertFile "�ļ�"
:: ���: ת���ļ�����
:: ˵��: ����ļ���������, ������ utf-8, ����ᵼ�������ض�

:convertFile

set convertfn=%~1

call :checkSedExist
call :checkFileExist "%convertfn%"

iconv -f gbk -t utf-8 %convertfn% > %convertfn%.tmp

move /y %convertfn%.tmp %convertfn% >nul

goto:eof
