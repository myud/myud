::+------------------------------------------------------------
::|     Batch - 下载 Myud 附件
::+------------------------------------------------------------

:: 使用: call 绝对路径\MyudDownload.bat
:: 结果: 
:: 说明: 

@echo off

set MyudDownloadPath=%~dp0

call %MyudDownloadPath%GnuWin32\GnuWin32.bat

:: 变量(下载)






















:: 变量(下载与解压)

set DownloadHoldRemove=/h

set MinIsoDir=%MyudDownloadPath%..
set MinIsoMd5=5848f2fd31c7acf3811ad88eaca6f4aa
set MinIsoUrl=http://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso
set MinIsoFile=CentOS-7-x86_64-Minimal-1708.iso
set MinIsoFilePath=%MinIsoDir%\%MinIsoFile%

set NetIsoDir=%MyudDownloadPath%..\LMT
set NetIsoMd5=75acc54b5825edb96a5a843996fd578b
rem NetIsoUrl=
set NetIsoFile=CentOS-7-x86_64-NetInstall-1708.iso
set NetIsoFilePath=%NetIsoDir%\%NetIsoFile%

rem 目录
set NetZipDir=%NetIsoDir%
rem MD5
set NetZipMd51=6e919504f50d4f49b94366e267fd557a
set NetZipMd52=80b73ed0bb84079260181b318cd2b434
set NetZipMd53=a922b8209d677d0909a3fdf6cc75420e
set NetZipMd54=f8e3f8659eddddcbe60366d13dfd0816
set NetZipMd55=b7154e6273687382a6382234d095cb56
rem URL
set NetZipUrl1=https://gitee.com/mydownload/myud-attachment/raw/master/attachment/CentOS-7-x86_64-NetInstall-1708/CentOS-7-x86_64-NetInstall-1708.zip.001
set NetZipUrl2=https://gitee.com/mydownload/myud-attachment/raw/master/attachment/CentOS-7-x86_64-NetInstall-1708/CentOS-7-x86_64-NetInstall-1708.zip.002
set NetZipUrl3=https://gitee.com/mydownload/myud-attachment/raw/master/attachment/CentOS-7-x86_64-NetInstall-1708/CentOS-7-x86_64-NetInstall-1708.zip.003
set NetZipUrl4=https://gitee.com/mydownload/myud-attachment/raw/master/attachment/CentOS-7-x86_64-NetInstall-1708/CentOS-7-x86_64-NetInstall-1708.zip.004
set NetZipUrl5=https://gitee.com/mydownload/myud-attachment/raw/master/attachment/CentOS-7-x86_64-NetInstall-1708/CentOS-7-x86_64-NetInstall-1708.zip.005
rem 文件
set NetZipFile1=CentOS-7-x86_64-NetInstall-1708.zip.001
set NetZipFile2=CentOS-7-x86_64-NetInstall-1708.zip.002
set NetZipFile3=CentOS-7-x86_64-NetInstall-1708.zip.003
set NetZipFile4=CentOS-7-x86_64-NetInstall-1708.zip.004
set NetZipFile5=CentOS-7-x86_64-NetInstall-1708.zip.005
rem 文件路径
set NetZipFilePath1=%NetZipDir%\%NetZipFile1%
rem 文件列表
set NetZipFileList=%NetZipFile1%,%NetZipFile2%,%NetZipFile3%,%NetZipFile4%,%NetZipFile5%

:: 变量(测试阿里云)

set AliyunHoldRemove=/r
set AliyunDir=%userprofile%\desktop
set AliyunMd5=f01b8a4a42218b55f0ced67a0875f06e
set AliyunUrl=http://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.torrent

:: 开始测试

:: 开始下载

:: 开始解压



































call MyudCaw.bat "%AliyunHoldRemove%" "%AliyunDir%" "%AliyunMd5%" "%AliyunUrl%"

call MyudCaw.bat "%DownloadHoldRemove%" "%MinIsoDir%" "%MinIsoMd5%" "%MinIsoUrl%"

call MyudCaw.bat "%DownloadHoldRemove%" "%NetZipDir%" "%NetZipMd51%" "%NetZipUrl1%"
call MyudCaw.bat "%DownloadHoldRemove%" "%NetZipDir%" "%NetZipMd52%" "%NetZipUrl2%"
call MyudCaw.bat "%DownloadHoldRemove%" "%NetZipDir%" "%NetZipMd53%" "%NetZipUrl3%"
call MyudCaw.bat "%DownloadHoldRemove%" "%NetZipDir%" "%NetZipMd54%" "%NetZipUrl4%"
call MyudCaw.bat "%DownloadHoldRemove%" "%NetZipDir%" "%NetZipMd55%" "%NetZipUrl5%"




:: 变量(解压)













:: 开始解压

for %%a in (%DownloadFileList%) do (
        if not exist %DownloadDirB%\%%a (
                echo,myuddownload - %%a not found!
                pause>nul
                exit 1
        )
)

:loop

7za x "%DownloadDirB%\%DownloadFileB1%" -y -aoa -o"%DownloadDirB%"

for /f "tokens=1* delims=;" %%a in ('md5 %DownloadDirB%\%DownloadFileB%') do (
        if /i not "%%b"=="%DownloadMd5B%" (
                if not "%MyudDownloadNum%"=="10" (
                        set MyudDownloadNum+=1
                        goto loop
                ) else (
                        echo,myuddownload - Decompression failed!
                        pause>nul
                        exit 1
                )
        )
)

goto :eof
