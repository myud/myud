::+------------------------------------------------------------
::|     Batch - Myud 下载工具
::+------------------------------------------------------------

:: 使用: call 绝对路径\MyudCaw.bat "URL"
:: 使用: call 绝对路径\MyudCaw.bat "目录" "URL"
:: 使用: call 绝对路径\MyudCaw.bat "/r或/h" "目录" "URL"
:: 使用: call 绝对路径\MyudCaw.bat "/r或/h" "目录" "MD5" "URL"
:: 结果: 
:: 说明: 

@echo off

set MyudCawPath=%~dp0

call %MyudCawPath%GnuWin32\GnuWin32.bat

:: 变量 MyudCawHoldRemove MyudCawDir MyudCawMd5 MyudCawUrl MyudCawFile MyudCawHttp

set argument1=%~1
set argument2=%~2
set argument3=%~3
set argument4=%~4

if defined argument4 (
        set MyudCawHoldRemove=%argument1%
        set MyudCawDir=%argument2%
        set MyudCawMd5=%argument3%
        set MyudCawUrl=%argument4%
) else (
        if defined argument3 (
                set MyudCawHoldRemove=%argument1%
                set MyudCawDir=%argument2%
                set MyudCawUrl=%argument3%
        ) else (
                if defined argument2 (
                        set MyudCawDir=%argument1%
                        set MyudCawUrl=%argument2%
                ) else (
                        if defined argument1 (
                                set MyudCawUrl=%argument1%
                        ) else (
                                goto :missingUrl
                        )
                )
        )
)

for /f %%a in ('echo %MyudCawUrl% ^| awk -F/ "{ if (NF>3) { print $NF } }"') do (
        set MyudCawFile=%%a
)

for /f "tokens=1* delims=:" %%a in ("%MyudCawUrl%") do (
        set MyudCawHttp=%%a
)

:: 检测 URL

echo %MyudCawUrl% | grep "^http[s]*://" >nul 2>nul || goto :missingUrl

if not defined MyudCawFile goto :missingUrl





goto :eof

:missingUrl

echo myudcaw - Missing url!
pause>nul
exit 1

goto :eof
