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


:: 用户



























rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof
















































































































































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
