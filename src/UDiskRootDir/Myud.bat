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
::|     Function - �滻�ַ���
::+------------------------------------------------------------

:: ʹ��: call :replaceStr "�ļ�" "ԭ�ַ���" "���ַ���"
:: ���: �滻�ļ�������, ������ UNIX ��ʽ���ļ�
:: ˵��: ����ı�ԭ�ļ�����

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


::+------------------------------------------------------------
::|     Function - ��� sed �������Ƿ����ִ��
::+------------------------------------------------------------

:: ʹ��: call :checkSedExist
:: ���: ������ִ�о��˳�
:: ˵��: GnuWin32\bin Ŀ¼�µ� sed, dos2unix, iconv

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

:: ʹ��: call :checkFileExist "�ļ�"
:: ���: �ļ������ھ��˳�
:: ˵��: 

:checkFileExist

if not exist %~1 (
        echo �ļ������� - %cd%\%~1
        pause>nul
        exit 1
)

goto:eof


::+------------------------------------------------------------
::|     Function - ��������U�̾���
::+------------------------------------------------------------

:: ʹ��: call :changeUdiskLabel "����"
:: ���: ����U�̾���
:: ˵��: 

:changeUdiskLabel

for /f "tokens=1-3" %%a in ('wmic logicaldisk get Description^,DeviceID^,VolumeName 2^>nul') do (
        if "%%a"=="���ƶ�����" (
                label %%b %~1
        )
)

goto:eof


::+------------------------------------------------------------
::|     Function - ������ȡU������
::+------------------------------------------------------------

:: ʹ��: call :getUdiskAttribute "Ŀ¼"
:: ���: ��ָ��Ŀ¼�´����ļ�
:: ˵��: 

:getUdiskAttribute

set usbDir=%~1
set "keyname=HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR\Enum"

if not exist %usbDir% (
        mkdir %usbDir%
)

for /f "tokens=1-3" %%a in ('reg query "%keyname%" /v Count 2^>nul') do (
        if "%%a"=="Count" (
                set /a countVar=%%c
        )
)

for /l %%a in (0,1,%countVar%) do (
        if "%%a" geq "1" (
                set /a usbNum=%%a-1
                
                setlocal enabledelayedexpansion
                
                for /f "tokens=1-3" %%b in ('reg query "%keyname%" 2^>nul') do (
                        if "%%b"=="!usbNum!" (
                                set usbAttribute=%%d
                                set usbVID=!usbAttribute:~8,4!
                                set usbPID=!usbAttribute:~17,4!
                                set usbSN=!usbAttribute:~22!
                                
                                echo !usbVID! !usbPID! !usbSN!>%usbDir%\udisk_!usbSN!
                        )
                )
                
                endlocal
        )
)

goto:eof