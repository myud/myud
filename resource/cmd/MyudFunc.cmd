@ECHO OFF

REM ������
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
        call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" "%Arg5%" "%Arg6%" "%Arg7%" "%Arg8%" "%Arg9%" 2>nul||call :Error "Main" "%Arg1% ��ǩ������"
) else (
        if defined Arg8 (
                call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" "%Arg5%" "%Arg6%" "%Arg7%" "%Arg8%" 2>nul||call :Error "Main" "%Arg1% ��ǩ������"
        ) else (
                if defined Arg7 (
                        call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" "%Arg5%" "%Arg6%" "%Arg7%" 2>nul||call :Error "Main" "%Arg1% ��ǩ������"
                ) else (
                        if defined Arg6 (
                                call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" "%Arg5%" "%Arg6%" 2>nul||call :Error "Main" "%Arg1% ��ǩ������"
                        ) else (
                                if defined Arg5 (
                                        call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" "%Arg5%" 2>nul||call :Error "Main" "%Arg1% ��ǩ������"
                                ) else (
                                        if defined Arg4 (
                                                call :%Arg1% "%Arg2%" "%Arg3%" "%Arg4%" 2>nul||call :Error "Main" "%Arg1% ��ǩ������"
                                        ) else (
                                                if defined Arg3 (
                                                        call :%Arg1% "%Arg2%" "%Arg3%" 2>nul||call :Error "Main" "%Arg1% ��ǩ������"
                                                ) else (
                                                        if defined Arg2 (
                                                                call :%Arg1% "%Arg2%" 2>nul||call :Error "Main" "%Arg1% ��ǩ������"
                                                        ) else (
                                                                if defined Arg1 (
                                                                        call :%Arg1% 2>nul||call :Error "Main" "%Arg1% ��ǩ������"
                                                                ) else (
                                                                        call :Error "Main" "ȱ�ٱ�ǩ����"
)))))))))


@GOTO:EOF


:Error
REM   func: ���������Ϣ�����˳�
REM   arg1: LabelName =Main            ���ִ���ı�ǩ����
REM   arg2: Message   =δ֪����        ��Ҫ����Ĵ�����Ϣ
REM return: 
SETLOCAL

set LabelName=%~1
set Message=%~2

:BEGIN

if not defined LabelName (
        set LabelName=Main
)

if not defined Message (
        set Message=δ֪����
)

echo,%~n0 - %LabelName% Error: %Message%!
pause>nul
exit 1

:END
(ENDLOCAL
        
)
GOTO:EOF
