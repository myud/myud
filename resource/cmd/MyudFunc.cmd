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






call :Error



@GOTO:EOF


:Error
REM   func: ��ʾ��Ϣ�����˳�
REM   arg1: LabelName - ��ǩ����
REM   arg2: Message   - ��ʾ��Ϣ
REM return: 
SETLOCAL

set LabelName=%~1
set Message=%~2

:BEGIN

if not defined LabelName (
        set LabelName=Unknown
)

if not defined Message (
        set Message=unknown
)

echo,%~n0 - %LabelName% Error: %Message%!
pause>nul
exit 1

:END
(ENDLOCAL
        
)
GOTO:EOF
