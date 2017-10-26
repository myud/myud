@ECHO OFF

set FuncPath=%~dp0
set FuncPath=%FuncPath:~0,-1%

set FuncName=%~1

if defined FuncName (
        call :%FuncName% %2 %3 %4 %5 %6 %7 %8 %9 2>nul||call :Error "Main" "%FuncName% 标签不存在"        &REM 检查标签最后一条语句
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


:Directory
REM   func: 将目录的相对路径转换为绝对路径
REM   arg1: Dir =          目录的相对路径或绝对路径
REM return: DirPath        目录的绝对路径
SETLOCAL

set Dir=%~1

:BEGIN

call :Argument "Directory" "Dir"

if /i "%Dir:~0,1%"=="\" (
        set Dir=%Dir:~1%
)

echo,%Dir%|findstr /i "^[c-z]:\\\\">nul 2>nul||set Dir=%cd%\%Dir%

if /i "%Dir:~-1%"=="\" (
        if /i not "%Dir:~-2%"==":\" (
                set Dir=%Dir:~0,-1%
        )
)

:END
(ENDLOCAL
        set DirPath=%Dir%
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
        set CommandPath=%PathList%        &REM 将局部变量 PathList 的值传递给全局变量 CommandPath
)

set Path=%CommandPath%;%Path%
GOTO:EOF


:MyudCaw
REM   func: Myud 的下载工具, 有检测 MD5 的功能
REM   arg1: HoldRemove =/r          可选, /r: 删除原文件重新下载, /h: 保留原文件不要下载 (如果存在 MD5 会直接检测 MD5)
REM   arg2: Dir        =%cd%        可选, 文件的保存目录, 默认值为当前目录
REM   arg3: MD5        =            可选, 文件的 MD5 值
REM   arg4: URL        =            必选, 下载地址
REM return: 
SETLOCAL

set HoldRemove=/r
set Dir=%cd%

set Arg1=%~1
set Arg2=%~2
set Arg3=%~3
set Arg4=%~4

:BEGIN_MyudCaw

::::call :CheckCommand

REM 变量 HoldRemove, Dir, MD5, URL, File, Http, FilePath
if defined Arg4 (
        set HoldRemove=%Arg1%
        set Dir=%Arg2%
        set MD5=%Arg3%
        set URL=%Arg4%
) else (
        if defined Arg3 (
                set HoldRemove=%Arg1%
                set Dir=%Arg2%
                set URL=%Arg3%
        ) else (
                if defined Arg2 (
                        set Dir=%Arg1%
                        set URL=%Arg2%
                ) else (
                        if defined Arg1 (
                                set URL=%Arg1%
                        ) else (
                                call :Error "MyudCaw" "缺少参数 URL"
))))

for /f %%a in ('echo,%URL%^|awk -F/ "{ if (NF>3) { print $NF } }"') do (
        set File=%%a
)

for /f "tokens=1* delims=:" %%a in ("%URL%") do (
        set Http=%%a
)

REM 检测 URL
echo,%URL%|grep "^http[s]*://.">nul 2>nul||call :Error "MyudCaw" "缺少参数 URL"

if not defined File (
        call :Error "MyudCaw" "URL 格式错误"
)

REM 检测目录
call :Directory %Dir%
set Dir=DirPath

REM 检测 HoldRemove, MD5
if /i not "%HoldRemove%"=="/r" (
        if /i not "%HoldRemove%"=="/h" (
                call :Error "MyudCaw" "%HoldRemove% 是无效选项"
        )
)

REM 检测 MD5
if defined MD5 (
        echo,%MD5%|grep "^[A-Za-z0-9]\{32\}$">nul 2>nul||call :Error "MyudCaw" "MD5 格式错误"
)

REM 创建目录
if not exist %Dir% (
        mkdir %Dir%
)

set FilePath=%Dir%\%File%

REM 删除文件
if exist %FilePath% (
        if /i "%HoldRemove%"=="/r" (
                del /f %FilePath%
        )
)

REM 下载文件并检测他的 MD5
for /l %%a in (1,1,10) do (
        
        if exist %FilePath% (
                
                if defined MD5 (
                        
                        echo,%~n0 - MyudCaw MD5Check: %FilePath%
                        
                        for /f "tokens=1* delims=;" %%x in ('md5 %FilePath%') do (
                                if /i not "%%y"=="%MD5%" (
                                        del /f %FilePath%
                                ) else (
                                        goto END_MyudCaw
                                )
                        )
                        
                ) else (
                        goto END_MyudCaw
                )
                
        ) else (
                
                if /i "%Http%"=="https" (
                        wget -c -P %Dir% --no-check-certificate %URL%
                ) else (
                        wget -c -P %Dir% %URL%
                )
                
        )
        
)

call :Error "MyudCaw" "%File% 下载失败"

:END_MyudCaw
(ENDLOCAL
        
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
