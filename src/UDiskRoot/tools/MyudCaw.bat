::+------------------------------------------------------------
::      Batch - Myud 下载工具
::
::      Usage: MyudCaw "/r或/h" "目录" "MD5" "URL"
::+------------------------------------------------------------
@echo off
color 0f
echo,%~n0 - Running...


rem start
set MyudCaw_Name=%~n0
set MyudCaw_Path=%~dp0

if exist %MyudCaw_Path%GnuWin32\GnuWin32.bat (
        call %MyudCaw_Path%GnuWin32\GnuWin32.bat
) else (
        call :exit "GnuWin32.bat not found!"
)

:: 变量
set MyudCawHoldRemove=/r
set MyudCawDir=%cd%

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
                                
                                call :exit "missing url!"
                                
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

:: 检测 URL, 目录, 选项, MD5
echo,%MyudCawUrl%|grep "^http[s]*://.">nul 2>nul||call :exit "missing url!"

if not defined MyudCawFile (call :exit "url error!")

if /i "%MyudCawDir:~0,1%"=="\" (
        set MyudCawDir=%MyudCawDir:~1%
)

echo,%MyudCawDir%|grep "^[C-Zc-z]:\\\\">nul 2>nul||set MyudCawDir=%cd%\%MyudCawDir%

if /i "%MyudCawDir:~-1%"=="\" (
        if /i not "%MyudCawDir:~-2%"==":\" (
                set MyudCawDir=%MyudCawDir:~0,-1%
        )
)

if /i not "%MyudCawHoldRemove%"=="/r" (
        if /i not "%MyudCawHoldRemove%"=="/h" (
                call :exit "unrecognized option %MyudCawHoldRemove%"
        )
)

if defined MyudCawMd5 (
        echo,%MyudCawMd5%|grep "^[A-Za-z0-9]\{32\}$">nul 2>nul||call :exit "md5 error!"
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
                        echo,%~n0 - MD5Check: %MyudCawFilePath%
                        
                        for /f "tokens=1* delims=;" %%b in ('md5 %MyudCawFilePath%') do (
                                if /i not "%%c"=="%MyudCawMd5%" (
                                        del /f %MyudCawFilePath%
                                ) else (
                                        goto skip
                                )
                        )
                ) else (
                        goto skip
                )
        ) else (
                if /i "%MyudCawHttp%"=="https" (
                        wget -c -P %MyudCawDir% --no-check-certificate %MyudCawUrl%
                ) else (
                        wget -c -P %MyudCawDir% %MyudCawUrl%
                )
        )
)

call :exit "%MyudCawFile% download failed!"

rem skip
:skip


rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof
