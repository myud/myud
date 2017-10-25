@ECHO OFF

REM 检查参数
set FuncPath=%~dp0
set FuncPath=%FuncPath:~0,-1%

set Arg1=%~1
set Arg2=%~2
set Arg3=%~3
set Arg4=%~4
set Arg5=%~5
set Arg6=%~6
set Arg7=%~7
set Arg8=%~8
set Arg9=%~9

if defined Arg9 (
        call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" "%Arg5%" "%Arg6%" "%Arg7%" "%Arg8%" "%Arg9%" 2>nul||call :Error "Main" "%Arg1% 标签不存在"
) else (
        if defined Arg8 (
                call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" "%Arg5%" "%Arg6%" "%Arg7%" "%Arg8%" 2>nul||call :Error "Main" "%Arg1% 标签不存在"
        ) else (
                if defined Arg7 (
                        call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" "%Arg5%" "%Arg6%" "%Arg7%" 2>nul||call :Error "Main" "%Arg1% 标签不存在"
                ) else (
                        if defined Arg6 (
                                call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" "%Arg5%" "%Arg6%" 2>nul||call :Error "Main" "%Arg1% 标签不存在"
                        ) else (
                                if defined Arg5 (
                                        call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" "%Arg5%" 2>nul||call :Error "Main" "%Arg1% 标签不存在"
                                ) else (
                                        if defined Arg4 (
                                                call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" 2>nul||call :Error "Main" "%Arg1% 标签不存在"
                                        ) else (
                                                if defined Arg3 (
                                                        call :%Arg1% "%Arg2%" "%Arg3%" 2>nul||call :Error "Main" "%Arg1% 标签不存在"
                                                ) else (
                                                        if defined Arg2 (
                                                                call :%Arg1% "%Arg2%" 2>nul||call :Error "Main" "%Arg1% 标签不存在"
                                                        ) else (
                                                                if defined Arg1 (
                                                                        call :%Arg1% 2>nul||call :Error "Main" "%Arg1% 标签不存在"
                                                                ) else (
                                                                        call :Error "Main" "缺少参数 标签名称"
)))))))))


@GOTO:EOF


:Error
REM   func: 输出错误信息并且退出
REM   arg1: LabelName =Main            出现错误的标签名称
REM   arg2: Message   =未知错误        想要输出的错误信息
REM return: 
SETLOCAL

set LabelName=%~1
set Message=%~2

:BEGIN

if not defined LabelName (
        set LabelName=Main
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
