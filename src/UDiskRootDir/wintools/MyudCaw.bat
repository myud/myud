::+------------------------------------------------------------
::|     Batch - Myud ���ع���
::+------------------------------------------------------------

:: ʹ��: call ����·��\MyudCaw.bat "URL"
:: ʹ��: call ����·��\MyudCaw.bat "Ŀ¼" "URL"
:: ʹ��: call ����·��\MyudCaw.bat "/r��/h" "Ŀ¼" "URL"
:: ʹ��: call ����·��\MyudCaw.bat "/r��/h" "Ŀ¼" "MD5" "URL"
:: ���: 
:: ˵��: 

@echo off

set MyudCawPath=%~dp0

call %MyudCawPath%GnuWin32\GnuWin32.bat

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
                                echo MyudCaw - missing url!
                                pause>nul
                                exit 1
                        )
                )
        )
)

for /f %%a in ('echo %MyudCawUrl% ^| awk -F/ "{ print $NF }"') do (
        set MyudCawFile=%%a
)

for /f "tokens=1* delims=:" %%a in ("%MyudCawUrl%") do (
        set MyudCawHttp=%%a
)













































































































