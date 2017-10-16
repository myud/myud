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

:: 使用: call :replaceStr "文件" "原字符串" "新字符串"
:: 结果: 替换文件的内容, 并生成 UNIX 格式的文件
:: 说明: 不会改变原文件编码

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

:: 使用: call :convertFile "文件"
:: 结果: 转换文件编码
:: 说明: 如果文件含有中文, 不能是 utf-8, 否则会导致乱码或截断

:convertFile

set convertfn=%~1

call :checkSedExist
call :checkFileExist "%convertfn%"

iconv -f gbk -t utf-8 %convertfn% > %convertfn%.tmp

move /y %convertfn%.tmp %convertfn% >nul

goto:eof


::+------------------------------------------------------------
::|     Function - 检测 sed 等命令是否可用执行
::+------------------------------------------------------------

:: 使用: call :checkSedExist
:: 结果: 不可以执行就退出
:: 说明: GnuWin32\bin 目录下的 sed, dos2unix, iconv

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

:: 使用: call :checkFileExist "文件"
:: 结果: 文件不存在就退出
:: 说明: 

:checkFileExist

if not exist %~1 (
        echo 文件不存在 - %cd%\%~1
        pause>nul
        exit 1
)

goto:eof


::+------------------------------------------------------------
::|     Function - 批量更改U盘卷标
::+------------------------------------------------------------

:: 使用: call :changeUdiskLabel "卷标"
:: 结果: 更改U盘卷标
:: 说明: 

:changeUdiskLabel

for /f "tokens=1-3" %%a in ('wmic logicaldisk get Description^,DeviceID^,VolumeName 2^>nul') do (
        if "%%a"=="可移动磁盘" (
                label %%b %~1
        )
)

goto:eof


::+------------------------------------------------------------
::|     Function - 批量获取U盘属性
::+------------------------------------------------------------

:: 使用: call :getUdiskAttribute "目录"
:: 结果: 在指定目录下创建文件
:: 说明: 

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
