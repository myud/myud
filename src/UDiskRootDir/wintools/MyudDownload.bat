::+------------------------------------------------------------
::|     Batch - 下载 Myud 附件
::+------------------------------------------------------------

:: 使用: call 绝对路径\MyudDownload.bat
:: 结果: 
:: 说明: 

@echo off

set MyudDownloadPath=%~dp0

call %MyudDownloadPath%GnuWin32\GnuWin32.bat

:: 变量

set DownloadHR=/h

set DownloadDirA=%MyudDownloadPath%..
set DownloadUrlA=http://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso
set DownloadMd5A=5848f2fd31c7acf3811ad88eaca6f4aa

set DownloadDirB=%MyudDownloadPath%..\LMT

set DownloadUrlB1=https://gitee.com/mydownload/myud-attachment/raw/master/attachment/CentOS-7-x86_64-NetInstall-1708/CentOS-7-x86_64-NetInstall-1708.zip.001
set DownloadUrlB2=https://gitee.com/mydownload/myud-attachment/raw/master/attachment/CentOS-7-x86_64-NetInstall-1708/CentOS-7-x86_64-NetInstall-1708.zip.002
set DownloadUrlB3=https://gitee.com/mydownload/myud-attachment/raw/master/attachment/CentOS-7-x86_64-NetInstall-1708/CentOS-7-x86_64-NetInstall-1708.zip.003
set DownloadUrlB4=https://gitee.com/mydownload/myud-attachment/raw/master/attachment/CentOS-7-x86_64-NetInstall-1708/CentOS-7-x86_64-NetInstall-1708.zip.004
set DownloadUrlB5=https://gitee.com/mydownload/myud-attachment/raw/master/attachment/CentOS-7-x86_64-NetInstall-1708/CentOS-7-x86_64-NetInstall-1708.zip.005

set DownloadMd5B1=6e919504f50d4f49b94366e267fd557a
set DownloadMd5B2=80b73ed0bb84079260181b318cd2b434
set DownloadMd5B3=a922b8209d677d0909a3fdf6cc75420e
set DownloadMd5B4=f8e3f8659eddddcbe60366d13dfd0816
set DownloadMd5B5=b7154e6273687382a6382234d095cb56

:: 测试阿里云

set AliyunTestUrl=http://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.torrent
set AliyunTestMd5=f01b8a4a42218b55f0ced67a0875f06e
call MyudCaw.bat "/r" "%userprofile%\desktop" "%AliyunTestMd5%" "%AliyunTestUrl%"

:: 开始下载

call MyudCaw.bat "%DownloadHR%" "%DownloadDirA%" "%DownloadMd5A%" "%DownloadUrlA%"

call MyudCaw.bat "%DownloadHR%" "%DownloadDirB%" "%DownloadMd5B1%" "%DownloadUrlB1%"
call MyudCaw.bat "%DownloadHR%" "%DownloadDirB%" "%DownloadMd5B2%" "%DownloadUrlB2%"
call MyudCaw.bat "%DownloadHR%" "%DownloadDirB%" "%DownloadMd5B3%" "%DownloadUrlB3%"
call MyudCaw.bat "%DownloadHR%" "%DownloadDirB%" "%DownloadMd5B4%" "%DownloadUrlB4%"
call MyudCaw.bat "%DownloadHR%" "%DownloadDirB%" "%DownloadMd5B5%" "%DownloadUrlB5%"

::

goto :eof
