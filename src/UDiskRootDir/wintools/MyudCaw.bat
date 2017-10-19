::+------------------------------------------------------------
::|     Batch - Myud 下载工具
::+------------------------------------------------------------

:: 使用: call 绝对路径\MyudCaw.bat "URL"
:: 使用: call 绝对路径\MyudCaw.bat "目录" "URL"
:: 使用: call 绝对路径\MyudCaw.bat "/r或/h" "目录" "URL"
:: 使用: call 绝对路径\MyudCaw.bat "/r或/h" "目录" "MD5" "URL"
:: 结果: 下载文件失败就退出
:: 说明: 

@echo off

set MyudCawPath=%~dp0

call %MyudCawPath%GnuWin32\GnuWin32.bat

:: 变量

set MyudCawHoldRemove=/r
set MyudCawDir=%cd%
rem MyudCawMd5=
rem MyudCawUrl=
rem MyudCawFile=
rem MyudCawHttp=

set MyudCawArgument1=%~1
set MyudCawArgument2=%~2
set MyudCawArgument3=%~3
set MyudCawArgument4=%~4

if defined MyudCawArgument4 (
        set MyudCawHoldRemove=%MyudCawArgument1%
        set MyudCawDir=%MyudCawArgument2%
        set MyudCawMd5=%MyudCawArgument3%
        set MyudCawUrl=%MyudCawArgument4%
) else (
        if defined MyudCawArgument3 (
                set MyudCawHoldRemove=%MyudCawArgument1%
                set MyudCawDir=%MyudCawArgument2%
                set MyudCawUrl=%MyudCawArgument3%
        ) else (
                if defined MyudCawArgument2 (
                        set MyudCawDir=%MyudCawArgument1%
                        set MyudCawUrl=%MyudCawArgument2%
                ) else (
                        if defined MyudCawArgument1 (
                                set MyudCawUrl=%MyudCawArgument1%
                        ) else (
                                goto missingUrl
                        )
                )
        )
)

for /f %%a in ('echo,%MyudCawUrl%^|awk -F/ "{ if (NF>3) { print $NF } }"') do (
        set MyudCawFile=%%a
)

for /f "tokens=1* delims=:" %%a in ("%MyudCawUrl%") do (
        set MyudCawHttp=%%a
)

:: 检测 URL

echo,%MyudCawUrl%|grep "^http[s]*://.">nul 2>nul||goto missingUrl

if not defined MyudCawFile goto missingUrl

:: 检测目录

if "%MyudCawDir:~0,1%"=="\" (
        set MyudCawDir=%MyudCawDir:~1%
)

echo,%MyudCawDir%|grep "^[C-Zc-z]:\\\\">nul 2>nul||set MyudCawDir=%cd%\%MyudCawDir%

if "%MyudCawDir:~-1%"=="\" (
        if not "%MyudCawDir:~-2%"==":\" (
                set MyudCawDir=%MyudCawDir:~0,-1%
        )
)

:: 检测选项

if /i not "%MyudCawHoldRemove%"=="/r" (
        if /i not "%MyudCawHoldRemove%"=="/h" (
                echo,myudcaw - Unrecognized option %MyudCawHoldRemove%!
                pause>nul
                exit 1
        )
)

:: 检测 MD5

if defined MyudCawMd5 (
        echo,%MyudCawMd5%|grep "^[A-Za-z0-9]\{32\}$">nul 2>nul||goto md5Error
)

:: 创建目录

if not exist %MyudCawDir% (
        mkdir %MyudCawDir%
)

set MyudCawFilePath=%MyudCawDir%\%MyudCawFile%

:: 删除文件

if exist %MyudCawFilePath% (
        if /i "%MyudCawHoldRemove%"=="/r" (
                del /f %MyudCawFilePath%
        )
)

:: 下载文件并检测 MD5

for /l %%a in (1,1,10) do (
        if exist %MyudCawFilePath% (
                if defined MyudCawMd5 (
                        for /f "tokens=1* delims=;" %%b in ('md5 %MyudCawFilePath%') do (
                                if /i not "%%c"=="%MyudCawMd5%" (
                                        del /f %MyudCawFilePath%
                                ) else (
                                        goto loop
                                )
                        )
                ) else (
                        goto loop
                )
        ) else (
                if /i "%MyudCawHttp%"=="https" (
                        wget -c -P %MyudCawDir% --no-check-certificate %MyudCawUrl%
                ) else (
                        wget -c -P %MyudCawDir% %MyudCawUrl%
                )
        )
        
        set MyudCawNum=%%a
)

:loop

:: 下载失败

if "%MyudCawNum%"=="10" (
        echo,myudcaw - %MyudCawFile% download failed!
        
        if /i "%MyudCawFile:~-8%"==".torrent" (
                echo,myudcaw - Aliyun.com causes...
        )
        
        pause>nul
        exit 1
)

:: 结束
goto :eof


:missingUrl

echo,myudcaw - Missing url!
pause>nul
exit 1

goto :eof


:md5Error

echo,myudcaw - Md5 error!
pause>nul
exit 1

goto :eof
