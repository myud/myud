::+------------------------------------------------------------
::|     Batch - Myud ���ع���
::+------------------------------------------------------------

:: ʹ��: call ·��\MyudCaw.bat "URL"
:: ʹ��: call ·��\MyudCaw.bat "Ŀ¼" "URL"
:: ʹ��: call ·��\MyudCaw.bat "/r��/h" "Ŀ¼" "URL"
:: ʹ��: call ·��\MyudCaw.bat "/r��/h" "Ŀ¼" "MD5" "URL"
:: ���: 
:: ˵��: 

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

