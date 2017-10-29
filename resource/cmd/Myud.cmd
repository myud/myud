@ECHO OFF

REM 初始化
title %~n0
color 0f

set MyudPath=%~dp0
set MyudPath=%MyudPath:~0,-1%

set MyudFunc=%MyudPath%\MyudFunc.cmd
set MenuNum=3

choice /t 1 /d y /n>nul

if not exist %MyudFunc% (
        echo,%~n0 - Main Error: %MyudFunc% 文件不存在!
        pause>nul
        exit 1
)

REM Usage: call %MyudFunc% 标签名称 "参数1" "参数2" "参数3"

call %MyudFunc% CheckUDisk "MYUD"

call %MyudFunc% CheckCommand

REM 交互 设置网络与密码
cls&echo,(1/%MenuNum%) 正在配置 CentOS 系统:
echo,

echo,
set /p Ipaddr=请输入你的  IP    (默认:192.168.1.5): 
if not defined Ipaddr (
        set Ipaddr=192.168.1.5
)

echo,
set /p Gateway=请输入你的网关    (默认:192.168.1.1): 
if not defined Gateway (
        set Gateway=192.168.1.1
)

echo,
set /p DNS=请输入你的 DNS    (默认:114.114.114.114): 
if not defined DNS (
        set DNS=114.114.114.114
)

echo,
set /p RootPassword=请输入 root  密码 (默认:123456): 
if not defined RootPassword (
        set RootPassword=123456
)

echo,
set /p AdminPassword=请输入 admin 密码 (默认:123456): 
if not defined AdminPassword (
        set AdminPassword=123456
)

REM 
cls&echo,(2/%MenuNum%) 启用或关闭 Myud 功能:
echo,








REM 
cls&echo,(3/%MenuNum%) 启用或关闭 Myud 功能:
echo,








REM 
cls&echo,配置完成!
echo,

echo,
echo,  你的  IP:        %Ipaddr%
echo,  你的网关:        %Gateway%
echo,  你的 DNS:        %DNS%
echo,root  密码:        %RootPassword%
echo,admin 密码:        %AdminPassword%




echo,
echo,请按任意键开始安装...
echo,
pause>nul






REM 
cls&echo,正在安装 请稍后...
echo,








REM 
cls&echo,安装完成!
echo,

echo,
echo,请按任意键退出...
echo,
pause>nul





REM 更改文件
cls
echo,正在运行, 请稍后...

call %MyudFunc% ChangeFile

REM 下载
call %MyudFunc% DownloadISO

REM 结束
cls
echo,已完成, 请退出...

echo,
echo,你的  IP:        %Ipaddr%
echo,你的网关:        %Gateway%
echo,你的 DNS:        %DNS%

echo,
pause>nul
exit 0

@GOTO:EOF


GOTO:EOF ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# Main Var
MyudPath
MyudFunc
Ipaddr
Gateway
DNS

# Func Var
FuncPath
FuncName
DirPath
CommandPath
