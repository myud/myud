@ECHO OFF


set FuncPath=%~dp0
set FuncPath=%FuncPath:~0,-1%

set FuncName=%~1


if defined FuncName (
        call :%FuncName% %2 %3 %4 %5 %6 %7 %8 %9 2>nul||call :Error "Main" "%FuncName% 标签不存在或语法错误"
) else (
        
        call :Error "Main" "缺少参数 标签名称"
)










@GOTO:EOF


:Error
REM   func: 输出错误信息并且退出
REM   arg1: LabelName =Unknown         出现错误的标签名称
REM   arg2: Message   =未知错误        想要输出的错误信息
REM return: 
SETLOCAL

set LabelName=%~1
set Message=%~2

:BEGIN

if not defined LabelName (
        set LabelName=Unknown
)

if not defined Message (
        set Message=未知错误
)

echo,%~n0 - %LabelName% Error: %Message%!
pause>nul
exit 1

:END
(ENDLOCAL
        
)
GOTO:EOF


:Argument
REM   func: 检查参数是否存在
REM   arg1: LabelName =        出现错误的标签名称
REM   arg2: ArgList   =        需要检查的参数列表, 如: arg1,arg2,arg3
REM return: 
SETLOCAL

set LabelName=%~1
set ArgList=%~2

:BEGIN

if not defined ArgList (
        call :Error "Argument" "缺少参数 参数列表"
)

for %%a in (%ArgList%) do (
        if not defined %%a (
                call :Error "%LabelName%" "缺少参数 %%a"
        )
)

:END
(ENDLOCAL
        
)
GOTO:EOF


:CheckUDisk
REM   func: 检查此程序是否位于U盘并更改U盘卷标
REM   arg1: UDiskLabel =        新的U盘卷标
REM return: 
SETLOCAL

set UDiskLabel=%~1

set KeyName=HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR\Enum

:BEGIN

call :Argument "CheckUDisk" "UDiskLabel"

for /f "tokens=1-3" %%a in ('reg query "%KeyName%" /v Count 2^>nul') do (
        if /i "%%a"=="Count" (
                set /a CountVar=%%c
        )
)

if /i "%CountVar%"=="0" (
        call :Error "CheckUDisk" "U盘不存在"
)

for /f "tokens=1-3" %%a in ('wmic logicaldisk get Description^,DeviceID^,VolumeName 2^>nul') do (
        if /i "%%a"=="可移动磁盘" (
                if /i "%%b\cmd"=="%FuncPath%" (
                        set DeviceID=%%b
                        set VolumeName=%%c
                )
        )
)

if not defined DeviceID (
        call :Error "CheckUDisk" "请将此程序复制到U盘根目录下运行"
)

echo,%VolumeName%|findstr "^%UDiskLabel%[0-9]*$">nul 2>nul||label %DeviceID% %UDiskLabel%

:END
(ENDLOCAL
        
)
GOTO:EOF


:CheckCommand
REM   func: 检查命令是否存在并设置环境变量
REM   arg1: 
REM return: CommandPath        所有命令的路径
SETLOCAL

set Command1=7za
set Command2=awk
set Command3=dos2unix
set Command4=grep
set Command5=iconv
set Command6=md5
set Command7=sed
set Command8=wget

set CommandList=%Command8%,%Command7%,%Command6%,%Command5%,%Command4%,%Command3%,%Command2%,%Command1%

set PathList=%FuncPath%\%Command8%\bin;%FuncPath%\%Command7%\bin;%FuncPath%\%Command6%\bin;%FuncPath%\%Command5%\bin;%FuncPath%\%Command4%\bin;%FuncPath%\%Command3%\bin;%FuncPath%\%Command2%\bin;%FuncPath%\%Command1%\bin

:BEGIN

for %%a in (%CommandList%) do (
        if not exist %FuncPath%\%%a\bin\%%a.exe (
                call :Error "CheckCommand" "%%a 命令不存在"
        )
)

:END
(ENDLOCAL
        set CommandPath=%PathList%
)

set Path=%CommandPath%;%Path%
GOTO:EOF


:#01
REM   func: #05
REM   arg1: #06 =#07        #08
REM return: #09_over
SETLOCAL

rem #02

:BEGIN

rem #03

:END
(ENDLOCAL
        rem #04
)
GOTO:EOF


:#01
REM   func: #05
REM   arg1: #06 =#07        #08
REM return: #09_over
SETLOCAL

rem #02

:BEGIN

rem #03

:END
(ENDLOCAL
        rem #04
)
GOTO:EOF


:#01
REM   func: #05
REM   arg1: #06 =#07        #08
REM return: #09_over
SETLOCAL

rem #02

:BEGIN

rem #03

:END
(ENDLOCAL
        rem #04
)
GOTO:EOF


:#01
REM   func: #05
REM   arg1: #06 =#07        #08
REM return: #09_over
SETLOCAL

rem #02

:BEGIN

rem #03

:END
(ENDLOCAL
        rem #04
)
GOTO:EOF


:#01
REM   func: #05
REM   arg1: #06 =#07        #08
REM return: #09_over
SETLOCAL

rem #02

:BEGIN

rem #03

:END
(ENDLOCAL
        rem #04
)
GOTO:EOF


:#01
REM   func: #05
REM   arg1: #06 =#07        #08
REM return: #09_over
SETLOCAL

rem #02

:BEGIN

rem #03

:END
(ENDLOCAL
        rem #04
)
GOTO:EOF


:#01
REM   func: #05
REM   arg1: #06 =#07        #08
REM return: #09_over
SETLOCAL

rem #02

:BEGIN

rem #03

:END
(ENDLOCAL
        rem #04
)
GOTO:EOF


:#01
REM   func: #05
REM   arg1: #06 =#07        #08
REM return: #09_over
SETLOCAL

rem #02

:BEGIN

rem #03

:END
(ENDLOCAL
        rem #04
)
GOTO:EOF


:#01
REM   func: #05
REM   arg1: #06 =#07        #08
REM return: #09_over
SETLOCAL

rem #02

:BEGIN

rem #03

:END
(ENDLOCAL
        rem #04
)
GOTO:EOF
