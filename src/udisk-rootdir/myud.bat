@echo off

title Myud
color 0f


::+------------------------------------------------------------
::|     用户
::+------------------------------------------------------------

:: 设置网络
echo/
set /p ipaddr= 请输入你的 IP  (默认:192.168.1.5): 

echo/
set /p gateway= 请输入你的网关 (默认:192.168.1.1): 

echo/
set /p dns= 请输入你的 DNS (默认:114.114.114.114): 

if not defined ipaddr (set ipaddr=192.168.1.5)
if not defined gateway (set gateway=192.168.1.1)
if not defined dns (set dns=114.114.114.114)


::+------------------------------------------------------------
::|     操作
::+------------------------------------------------------------

cls
echo 正在运行, 请稍候...

:: 替换文件内容
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
::|     结束
::+------------------------------------------------------------

cls
color 0a
echo +------------------------------------------------------------
echo ^|
echo ^|                          配置成功
echo ^|
echo +------------------------------------------------------------

echo/
echo 你的 IP:     %ipaddr%
echo 你的网关:    %gateway%
echo 你的 DNS:    %dns%

echo/
echo/
echo/
echo 请退出...

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
::|     Function - 转换文件编码
::+------------------------------------------------------------

:convertFile

set convertfn=%~1

call :checkSedExist
call :checkFileExist "%convertfn%"

iconv -f gbk -t utf-8 %convertfn% > %convertfn%.tmp

move /y %convertfn%.tmp %convertfn% >nul

goto:eof


::+------------------------------------------------------------
::|     Function - 检测 sed 等命令是否存在
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

dos2unix --help>nul 2>nul

if not "%errorlevel%"=="0" (
        echo dos2unix - 没有找到!
        pause>nul
        exit 1
)

iconv --help>nul 2>nul

if not "%errorlevel%"=="0" (
        echo iconv - 没有找到!
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
