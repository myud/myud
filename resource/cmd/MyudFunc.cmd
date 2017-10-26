@ECHO OFF

set FuncPath=%~dp0
set FuncPath=%FuncPath:~0,-1%

set FuncName=%~1

if defined FuncName (
        call :%FuncName% %2 %3 %4 %5 %6 %7 %8 %9 2>nul||call :Error "Main" "%FuncName% ��ǩ������"        &REM ����ǩ���һ�����
) else (
        call :Error "Main" "ȱ�ٲ��� ��ǩ����"
)

@GOTO:EOF


:Error
REM   func: ���������Ϣ�����˳�
REM   arg1: LabelName =Unknown         ���ִ���ı�ǩ����
REM   arg2: Message   =δ֪����        ��Ҫ����Ĵ�����Ϣ
REM return: 
SETLOCAL

set LabelName=%~1
set Message=%~2

:BEGIN

if not defined LabelName (
        set LabelName=Unknown
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


:Argument
REM   func: �������Ƿ����
REM   arg1: LabelName =        ���ִ���ı�ǩ����
REM   arg2: ArgList   =        ��Ҫ���Ĳ����б�, ��: arg1,arg2,arg3
REM return: 
SETLOCAL

set LabelName=%~1
set ArgList=%~2

:BEGIN

if not defined ArgList (
        call :Error "Argument" "ȱ�ٲ��� �����б�"
)

for %%a in (%ArgList%) do (
        if not defined %%a (
                call :Error "%LabelName%" "ȱ�ٲ��� %%a"
        )
)

:END
(ENDLOCAL
        
)
GOTO:EOF


:Directory
REM   func: ��Ŀ¼�����·��ת��Ϊ����·��
REM   arg1: Dir =          Ŀ¼�����·�������·��
REM return: DirPath        Ŀ¼�ľ���·��
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
REM   func: ���˳����Ƿ�λ��U�̲�����U�̾��
REM   arg1: UDiskLabel =        �µ�U�̾��
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
        call :Error "CheckUDisk" "U�̲�����"
)

for /f "tokens=1-3" %%a in ('wmic logicaldisk get Description^,DeviceID^,VolumeName 2^>nul') do (
        if /i "%%a"=="���ƶ�����" (
                if /i "%%b\cmd"=="%FuncPath%" (
                        set DeviceID=%%b
                        set VolumeName=%%c
                )
        )
)

if not defined DeviceID (
        call :Error "CheckUDisk" "�뽫�˳����Ƶ�U�̸�Ŀ¼������"
)

echo,%VolumeName%|findstr "^%UDiskLabel%[0-9]*$">nul 2>nul||label %DeviceID% %UDiskLabel%

:END
(ENDLOCAL
        
)
GOTO:EOF


:CheckCommand
REM   func: ��������Ƿ���ڲ����û�������
REM   arg1: 
REM return: CommandPath        ���������·��
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
                call :Error "CheckCommand" "%%a �������"
        )
)

:END
(ENDLOCAL
        set CommandPath=%PathList%        &REM ���ֲ����� PathList ��ֵ���ݸ�ȫ�ֱ��� CommandPath
)

set Path=%CommandPath%;%Path%
GOTO:EOF


:MyudCaw
REM   func: Myud �����ع���, �м�� MD5 �Ĺ���
REM   arg1: HoldRemove =/r          ��ѡ, /r: ɾ��ԭ�ļ���������, /h: ����ԭ�ļ���Ҫ���� (������� MD5 ��ֱ�Ӽ�� MD5)
REM   arg2: Dir        =%cd%        ��ѡ, �ļ��ı���Ŀ¼, Ĭ��ֵΪ��ǰĿ¼
REM   arg3: MD5        =            ��ѡ, �ļ��� MD5 ֵ
REM   arg4: URL        =            ��ѡ, ���ص�ַ
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

REM ���� HoldRemove, Dir, MD5, URL, File, Http, FilePath
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
                                call :Error "MyudCaw" "ȱ�ٲ��� URL"
))))

for /f %%a in ('echo,%URL%^|awk -F/ "{ if (NF>3) { print $NF } }"') do (
        set File=%%a
)

for /f "tokens=1* delims=:" %%a in ("%URL%") do (
        set Http=%%a
)

REM ��� URL
echo,%URL%|grep "^http[s]*://.">nul 2>nul||call :Error "MyudCaw" "ȱ�ٲ��� URL"

if not defined File (
        call :Error "MyudCaw" "URL ��ʽ����"
)

REM ���Ŀ¼
call :Directory %Dir%
set Dir=DirPath

REM ��� HoldRemove, MD5
if /i not "%HoldRemove%"=="/r" (
        if /i not "%HoldRemove%"=="/h" (
                call :Error "MyudCaw" "%HoldRemove% ����Чѡ��"
        )
)

REM ��� MD5
if defined MD5 (
        echo,%MD5%|grep "^[A-Za-z0-9]\{32\}$">nul 2>nul||call :Error "MyudCaw" "MD5 ��ʽ����"
)

REM ����Ŀ¼
if not exist %Dir% (
        mkdir %Dir%
)

set FilePath=%Dir%\%File%

REM ɾ���ļ�
if exist %FilePath% (
        if /i "%HoldRemove%"=="/r" (
                del /f %FilePath%
        )
)

REM �����ļ���������� MD5
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

call :Error "MyudCaw" "%File% ����ʧ��"

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
