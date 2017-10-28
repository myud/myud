@ECHO OFF

set FuncPath=%~dp0
set FuncPath=%FuncPath:~0,-1%

set FuncName=%~1

REM ��ǩ���һ�����ִ��ʧ��Ҳ����ʾ ��ǩ������
if defined FuncName (
        call :%FuncName% %2 %3 %4 %5 %6 %7 %8 %9||(cls&call :Error "Main" "%FuncName% ��ǩ������")
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

set Current=%cd%

:BEGIN

call :Argument "Directory" "Dir"

if /i "%Current:~-1%"=="\" (
        set Current=%Current:~0,-1%
)

if /i "%Dir:~0,1%"=="\" (
        set Dir=%Dir:~1%
)

echo,%Dir%|findstr /i "^[c-z]:\\\\">nul 2>nul||set Dir=%Current%\%Dir%

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
        REM ���ֲ����� PathList ��ֵ���ݸ�ȫ�ֱ��� CommandPath
        set CommandPath=%PathList%
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
set Dir=%DirPath%

REM ��� HoldRemove
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

REM �����ļ������ MD5 ֵ
for /l %%a in (1,1,10) do (
        
        if exist %FilePath% (
                
                if defined MD5 (
                        
                        echo,%~n0 - MyudCaw MD5Check: %FilePath%
                        
                        for /f "tokens=1*" %%z in ('md5 %FilePath%') do (
                                if /i not "%%z"=="%MD5%" (
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


:DownloadISO
REM   func: ���� ISO �ļ�
REM   arg1: 
REM return: 
SETLOCAL

REM HoldRemove
set HR=/h

REM Ŀ¼
set RootDir=%FuncPath%\..
set LMTDir=%RootDir%\LMT
set ImagesDir=%LMTDir%\images

REM MD5
set MinISOMD5=5848f2fd31c7acf3811ad88eaca6f4aa
set NetISOMD5=75acc54b5825edb96a5a843996fd578b

set NetZipMD51=6e919504f50d4f49b94366e267fd557a
set NetZipMD52=80b73ed0bb84079260181b318cd2b434
set NetZipMD53=a922b8209d677d0909a3fdf6cc75420e
set NetZipMD54=f8e3f8659eddddcbe60366d13dfd0816
set NetZipMD55=b7154e6273687382a6382234d095cb56

set ImgZipMD5=f01abc3decf5c91ab3617601e091f188

REM URL
set MinISOURL=http://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso

set NetZipURL1=https://gitee.com/mydownload/myud-attachment/raw/master/resource/LMT/CentOS-7-x86_64-NetInstall-1708.zip.001
set NetZipURL2=https://gitee.com/mydownload/myud-attachment/raw/master/resource/LMT/CentOS-7-x86_64-NetInstall-1708.zip.002
set NetZipURL3=https://gitee.com/mydownload/myud-attachment/raw/master/resource/LMT/CentOS-7-x86_64-NetInstall-1708.zip.003
set NetZipURL4=https://gitee.com/mydownload/myud-attachment/raw/master/resource/LMT/CentOS-7-x86_64-NetInstall-1708.zip.004
set NetZipURL5=https://gitee.com/mydownload/myud-attachment/raw/master/resource/LMT/CentOS-7-x86_64-NetInstall-1708.zip.005

set ImgZipURL=https://gitee.com/mydownload/myud-attachment/raw/master/resource/LMT/images.zip

REM �ļ�
set MinISOFilePath=%RootDir%\CentOS-7-x86_64-Minimal-1708.iso
set NetISOFilePath=%LMTDir%\CentOS-7-x86_64-NetInstall-1708.iso

set NetZipFile1=CentOS-7-x86_64-NetInstall-1708.zip.001
set NetZipFile2=CentOS-7-x86_64-NetInstall-1708.zip.002
set NetZipFile3=CentOS-7-x86_64-NetInstall-1708.zip.003
set NetZipFile4=CentOS-7-x86_64-NetInstall-1708.zip.004
set NetZipFile5=CentOS-7-x86_64-NetInstall-1708.zip.005
set NetZipFilePath1=%LMTDir%\%NetZipFile1%
set NetZipFileList=%NetZipFile1%,%NetZipFile2%,%NetZipFile3%,%NetZipFile4%,%NetZipFile5%

set ImgZipFilePath=%LMTDir%\images.zip
set ImagesFileList=TRANS.TBL,efiboot.img,pxeboot\TRANS.TBL,pxeboot\initrd.img,pxeboot\vmlinuz

REM ������
set AliyunDir=%UserProfile%\Desktop
set AliyunMD5=f01b8a4a42218b55f0ced67a0875f06e
set AliyunURL=http://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.torrent
set AliyunFilePath=%AliyunDir%\CentOS-7-x86_64-Minimal-1708.torrent

:BEGIN_DownloadISO

::::call :CheckCommand

REM ��Ⱒ�����Ƿ��Ѿ�����
if not exist %MinISOFilePath% (
        call :MyudCaw /r %AliyunDir% %AliyunMD5% %AliyunURL%
        del /f %AliyunFilePath%
)

REM ���� images.zip
for %%a in (%ImagesFileList%) do (
        if not exist %ImagesDir%\%%a (
                set MissingFile=%%a
        )
)

if defined MissingFile (
        call :MyudCaw %HR% %LMTDir% %ImgZipMD5% %ImgZipURL%
        7za x "%ImgZipFilePath%" -y -aoa -o"%LMTDir%"
)

REM ���� CentOS-7-x86_64-NetInstall-1708.iso
if exist %NetISOFilePath% (
        echo,%~n0 - DownloadISO MD5Check: %NetISOFilePath%
        
        for /f "tokens=1*" %%z in ('md5 %NetISOFilePath%') do (
                if /i "%%z"=="%NetISOMD5%" (
                        goto SKIP_DownloadISO
                )
        )
)

call :MyudCaw %HR% %LMTDir% %NetZipMD51% %NetZipURL1%
call :MyudCaw %HR% %LMTDir% %NetZipMD52% %NetZipURL2%
call :MyudCaw %HR% %LMTDir% %NetZipMD53% %NetZipURL3%
call :MyudCaw %HR% %LMTDir% %NetZipMD54% %NetZipURL4%
call :MyudCaw %HR% %LMTDir% %NetZipMD55% %NetZipURL5%

for /l %%a in (1,1,10) do (
        
        for %%b in (%NetZipFileList%) do (
                if not exist %LMTDir%\%%b (
                        call :Error "DownloadISO" "%LMTDir%\%%b �ļ�������"
                )
        )
        
        7za x "%NetZipFilePath1%" -y -aoa -o"%LMTDir%"
        
        echo,%~n0 - DownloadISO MD5Check: %NetISOFilePath%
        
        for /f "tokens=1*" %%z in ('md5 %NetISOFilePath%') do (
                if /i "%%z"=="%NetISOMD5%" (
                        goto SKIP_DownloadISO
                )
        )
        
)

call :Error "DownloadISO" "%NetZipFilePath1% ��ѹʧ��"

:SKIP_DownloadISO

REM ���� CentOS-7-x86_64-Minimal-1708.iso
call :MyudCaw %HR% %RootDir% %MinISOMD5% %MinISOURL%

REM ɾ��ѹ����
if exist %ImgZipFilePath% (
        del /f %ImgZipFilePath%
)

for %%a in (%NetZipFileList%) do (
        if exist %LMTDir%\%%a (
                del /f %LMTDir%\%%a
        )
)

:END_DownloadISO
(ENDLOCAL
        
)
GOTO:EOF


:ReplaceStr
REM   func: �滻�ַ����Ҳ���ı�ԭ�����ļ�����
REM   arg1: OldStr =        ԭ�ַ���
REM   arg1: NewStr =        ���ַ���
REM   arg1: File   =        �ļ��ľ���·�������·��
REM return: 
SETLOCAL

set OldStr=%~1
set NewStr=%~2
set File=%~3

:BEGIN

::::call :CheckCommand

call :Argument "ReplaceStr" "OldStr,NewStr,File"

if /i "%File:~-1%"=="\" (
        call :Error "ReplaceStr" "�ļ����Ƹ�ʽ����"
)

call :Directory %File%
set File=%DirPath%

if not exist %File% (
        call :Error "ReplaceStr" "%File% �ļ�������"
)

sed -i "s/%OldStr%/%NewStr%/g" %File%

dos2unix %File%>nul 2>nul

REM ��ǰĿ¼��
for %%a in (sed*) do (
        echo,%%a|grep "^sed[A-Za-z0-9]\{6\}$">nul 2>nul&&del /f %%a
)

:END
(ENDLOCAL
        
)
GOTO:EOF


:ChangeFile
REM   func: �����ļ� ks.cfg �� config_network.sh
REM   arg1: 
REM return: 
SETLOCAL

set KSDefault=%FuncPath%\..\data\ks.cfg.default
set KS=%FuncPath%\..\ks.cfg

set NetworkDefault=%FuncPath%\..\data\config_network.sh.default
set Network=%FuncPath%\..\config_network.sh

:BEGIN

if not exist %KSDefault% (
        call :Error "ChangeFile" "%KSDefault% �ļ�������"
)

if not exist %NetworkDefault% (
        call :Error "ChangeFile" "%NetworkDefault% �ļ�������"
)

copy /y %KSDefault% %KS%>nul
copy /y %NetworkDefault% %Network%>nul

call :ReplaceStr "##custom##192\.168\.1\.5##" "%Ipaddr%" "%KS%"
call :ReplaceStr "##custom##192\.168\.1\.1##" "%Gateway%" "%KS%"
call :ReplaceStr "##custom##114\.114\.114\.114##" "%DNS%" "%KS%"

call :ReplaceStr "##custom##192\.168\.1\.5##" "%Ipaddr%" "%Network%"
call :ReplaceStr "##custom##192\.168\.1\.1##" "%Gateway%" "%Network%"
call :ReplaceStr "##custom##114\.114\.114\.114##" "%DNS%" "%Network%"

:END
(ENDLOCAL
        
)
GOTO:EOF


GOTO:EOF ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


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
