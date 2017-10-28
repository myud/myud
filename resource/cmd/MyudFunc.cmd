@ECHO OFF

set FuncPath=%~dp0
set FuncPath=%FuncPath:~0,-1%

set FuncName=%~1

REM 标签最后一条语句执行失败也会显示 标签不存在
if defined FuncName (
        call :%FuncName% %2 %3 %4 %5 %6 %7 %8 %9||(cls&call :Error "Main" "%FuncName% 标签不存在")
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
        REM 将局部变量 PathList 的值传递给全局变量 CommandPath
        set CommandPath=%PathList%
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
set Dir=%DirPath%

REM 检测 HoldRemove
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

REM 下载文件并检测 MD5 值
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

call :Error "MyudCaw" "%File% 下载失败"

:END_MyudCaw
(ENDLOCAL
        
)
GOTO:EOF


:DownloadISO
REM   func: 下载 ISO 文件
REM   arg1: 
REM return: 
SETLOCAL

REM HoldRemove
set HR=/h

REM 目录
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

REM 文件
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

REM 阿里云
set AliyunDir=%UserProfile%\Desktop
set AliyunMD5=f01b8a4a42218b55f0ced67a0875f06e
set AliyunURL=http://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.torrent
set AliyunFilePath=%AliyunDir%\CentOS-7-x86_64-Minimal-1708.torrent

:BEGIN_DownloadISO

::::call :CheckCommand

REM 检测阿里云是否已经更新
if not exist %MinISOFilePath% (
        call :MyudCaw /r %AliyunDir% %AliyunMD5% %AliyunURL%
        del /f %AliyunFilePath%
)

REM 下载 images.zip
for %%a in (%ImagesFileList%) do (
        if not exist %ImagesDir%\%%a (
                set MissingFile=%%a
        )
)

if defined MissingFile (
        call :MyudCaw %HR% %LMTDir% %ImgZipMD5% %ImgZipURL%
        7za x "%ImgZipFilePath%" -y -aoa -o"%LMTDir%"
)

REM 下载 CentOS-7-x86_64-NetInstall-1708.iso
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
                        call :Error "DownloadISO" "%LMTDir%\%%b 文件不存在"
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

call :Error "DownloadISO" "%NetZipFilePath1% 解压失败"

:SKIP_DownloadISO

REM 下载 CentOS-7-x86_64-Minimal-1708.iso
call :MyudCaw %HR% %RootDir% %MinISOMD5% %MinISOURL%

REM 删除压缩包
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
REM   func: 替换字符串且不会改变原来的文件编码
REM   arg1: OldStr =        原字符串
REM   arg1: NewStr =        新字符串
REM   arg1: File   =        文件的绝对路径或相对路径
REM return: 
SETLOCAL

set OldStr=%~1
set NewStr=%~2
set File=%~3

:BEGIN

::::call :CheckCommand

call :Argument "ReplaceStr" "OldStr,NewStr,File"

if /i "%File:~-1%"=="\" (
        call :Error "ReplaceStr" "文件名称格式错误"
)

call :Directory %File%
set File=%DirPath%

if not exist %File% (
        call :Error "ReplaceStr" "%File% 文件不存在"
)

sed -i "s/%OldStr%/%NewStr%/g" %File%

dos2unix %File%>nul 2>nul

REM 当前目录下
for %%a in (sed*) do (
        echo,%%a|grep "^sed[A-Za-z0-9]\{6\}$">nul 2>nul&&del /f %%a
)

:END
(ENDLOCAL
        
)
GOTO:EOF


:ChangeFile
REM   func: 更改文件 ks.cfg 与 config_network.sh
REM   arg1: 
REM return: 
SETLOCAL

set KSDefault=%FuncPath%\..\data\ks.cfg.default
set KS=%FuncPath%\..\ks.cfg

set NetworkDefault=%FuncPath%\..\data\config_network.sh.default
set Network=%FuncPath%\..\config_network.sh

:BEGIN

if not exist %KSDefault% (
        call :Error "ChangeFile" "%KSDefault% 文件不存在"
)

if not exist %NetworkDefault% (
        call :Error "ChangeFile" "%NetworkDefault% 文件不存在"
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
