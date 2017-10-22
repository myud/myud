@echo off
����
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

::
::start /max "" "http://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso"
::choice /t 5 /d y /n >nul
::start /max "" "https://pan.baidu.com/s/1dEQfc7v"


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
