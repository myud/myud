::+------------------------------------------------------------
::      Batch - 下载 Myud 附件
::
::      Usage: MyudDownload
::+------------------------------------------------------------
@echo off
color 0f
echo,%~n0 - Running...


rem start
set MyudDownload_Name=%~n0
set MyudDownload_Path=%~dp0

call %MyudDownload_Path%GnuWin32\GnuWin32.bat

:: 变量 (下载与解压)
set DownloadHoldRemove=/h

set MinIsoDir=%MyudDownload_Path%..
set MinIsoMd5=5848f2fd31c7acf3811ad88eaca6f4aa
set MinIsoUrl=http://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso
set MinIsoFile=CentOS-7-x86_64-Minimal-1708.iso
set MinIsoFilePath=%MinIsoDir%\%MinIsoFile%

set NetIsoDir=%MyudDownload_Path%..\LMT
set NetIsoMd5=75acc54b5825edb96a5a843996fd578b
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

:: 变量 (测试阿里云)
set AliyunHoldRemove=/r
set AliyunDir=%userprofile%\desktop
set AliyunMd5=f01b8a4a42218b55f0ced67a0875f06e
set AliyunUrl=http://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.torrent
set AliyunFile=CentOS-7-x86_64-Minimal-1708.torrent

:: 开始测试
if not exist %MinIsoFilePath% (
        call MyudCaw.bat "%AliyunHoldRemove%" "%AliyunDir%" "%AliyunMd5%" "%AliyunUrl%"
        del /f %AliyunDir%\%AliyunFile%
)

:: 开始下载
call MyudCaw.bat "%DownloadHoldRemove%" "%MinIsoDir%" "%MinIsoMd5%" "%MinIsoUrl%"

if not exist %NetIsoFilePath% (
        call :downloadNetIso
) else (
        echo,%~n0 - MD5Check: %NetIsoFilePath%
        
        for /f "tokens=1* delims=;" %%a in ('md5 %NetIsoFilePath%') do (
                if /i not "%%b"=="%NetIsoMd5%" (
                        call :downloadNetIso
                )
        )
)


rem end
goto:eof


rem label
:exit
echo,%~n0 - Error: %~1
pause>nul
exit 1
goto:eof


:downloadNetIso

call MyudCaw.bat "%DownloadHoldRemove%" "%NetZipDir%" "%NetZipMd51%" "%NetZipUrl1%"
call MyudCaw.bat "%DownloadHoldRemove%" "%NetZipDir%" "%NetZipMd52%" "%NetZipUrl2%"
call MyudCaw.bat "%DownloadHoldRemove%" "%NetZipDir%" "%NetZipMd53%" "%NetZipUrl3%"
call MyudCaw.bat "%DownloadHoldRemove%" "%NetZipDir%" "%NetZipMd54%" "%NetZipUrl4%"
call MyudCaw.bat "%DownloadHoldRemove%" "%NetZipDir%" "%NetZipMd55%" "%NetZipUrl5%"

for /l %%a in (1,1,10) do (
        
        for %%b in (%NetZipFileList%) do (
                if not exist %NetZipDir%\%%b (
                        call :exit "%%b not found!"
                )
        )
        
        7za x "%NetZipFilePath1%" -y -aoa -o"%NetZipDir%"
        
        echo,%~n0 - MD5Check: %NetIsoFilePath%
        
        for /f "tokens=1* delims=;" %%c in ('md5 %NetIsoFilePath%') do (
                if /i "%%d"=="%NetIsoMd5%" (
                        goto skip
                )
        )
)

call :exit "decompression failed!"

rem skip
:skip

for %%a in (%NetZipFileList%) do (
        if exist %NetZipDir%\%%a (
                del /f %NetZipDir%\%%a
        )
)

goto:eof
