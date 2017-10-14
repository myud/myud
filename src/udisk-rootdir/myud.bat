@echo off

title myud
color 0f

set file1=.ks.cfg.bak
set file2=.ks.cfg.tmp

call :checkFileExist "%file1%"
copy /y %file1% ks.cfg >nul

echo/
set /p ipaddr= 请输入你的 IP (默认值 192.168.1.5): 
echo/
set /p gateway= 请输入你的网关 (默认值 192.168.1.1): 
echo/
set /p dns= 请输入你的 DNS (默认值 114.114.114.114): 

if not defined ipaddr (set ipaddr=192.168.1.5)
if not defined gateway (set gateway=192.168.1.1)
if not defined dns (set dns=114.114.114.114)

call :replaceStr "ks.cfg" "qinweijunlin" "%ipaddr%" "%file2%"
call :replaceStr "ks.cfg" "qinweijunlin" "%gateway%" "%file2%"
call :replaceStr "ks.cfg" "qinweijunlin" "%dns%" "%file2%"

cls
color 0a

echo/
echo 配置完成
echo/
echo 你的 IP:     %ipaddr%
echo 你的网关:    %gateway%
echo 你的 DNS:    %dns%
echo/

pause >nul

:: --------------------------------------------------
:: Function - 检查文件是否存在
:: --------------------------------------------------

:checkFileExist

if not exist %~1 (
        echo 错误: '%~1' 文件不存在
        pause >nul
        exit 1
)

goto:eof

:: --------------------------------------------------
:: Function - 替换字符串
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
