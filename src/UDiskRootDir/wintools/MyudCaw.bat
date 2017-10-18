::+------------------------------------------------------------
::|     Batch - Myud 下载工具
::+------------------------------------------------------------

:: 使用: call 路径\MyudCaw.bat "URL"
:: 使用: call 路径\MyudCaw.bat "目录" "URL"
:: 使用: call 路径\MyudCaw.bat "/r或/h" "目录" "URL"
:: 使用: call 路径\MyudCaw.bat "/r或/h" "目录" "MD5" "URL"
:: 结果: 
:: 说明: 

@echo off

set MyudCawPath=%~dp0

call GnuWin32\GnuWin32.bat

set argument1=%~1
set argument2=%~2
set argument3=%~3
set argument4=%~4

if defined argument4 (
        echo %argument4%
)

if defined argument3 (
        echo %argument3%
)

if defined argument2 (
        echo %argument2%
)

if defined argument1 (
        echo %argument1%
)

