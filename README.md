# Myud (My UDisk)

内容目录：

 - [重要说明][1]
 - [安装 Myud][2]
 - [自动安装 CentOS-7.4-x86_64][3]
 - [手动安装 CentOS-7.4-x86_64][4]
 - [相关文档][5]

## 重要说明

硬件要求：

 - 仅支持一块 500G 以上的 SATA 硬盘
 - 需要一个 4G 以上的U盘
 - 需要 CentOS 将硬盘识别为 `sda`，将U盘识别为 `sdb`

## 安装 Myud

 - 请下载 [老毛桃U盘启动盘制作工具][6] 及 [Myud.exe][7]
 - 先使用 老毛桃U盘启动盘制作工具 将U盘制作成 `启动U盘`
 - 然后把 Myud.exe 拷贝到U盘 `根目录` 下运行
 - 根据提示完成安装

## 自动安装 CentOS-7.4-x86_64

**1. 开始安装：**

 - 开机从U盘启动
 - 依次执行：

    \[10] 启动自定义ISO/IMG文件（LMT目录）
    
    [02] 自动搜索并列出LMT目录下所有文件
    
    [03] RUN CentOS-7-x86_64-NetInstall-1708.iso
    
    Install CentOS 7

 - 如果启用了挂载硬盘的功能，安装完成后会自动关机
 - 增加硬盘后开机

**2. 挂载硬盘：**

 - 如果硬盘已经分区，并且格式化为 `xfs`
 - 就可以直接挂载硬盘

例如：

    systemctl start   backup.mount
    systemctl stop    backup.mount
    
    systemctl restart backup.mount
    systemctl status  backup.mount
    
    systemctl enable  backup.mount
    systemctl disable backup.mount

 - 也可以自动挂载硬盘

例如：

    systemctl stop    backup.mount
    systemctl disable backup.mount
    
    
    systemctl start   backup.automount
    systemctl stop    backup.automount
    
    systemctl restart backup.automount
    systemctl status  backup.automount
    
    systemctl enable  backup.automount
    systemctl disable backup.automount

**3. 挂载U盘：**

如果U盘的文件系统为 `vfat`，就可以自动挂载U盘：

 - U盘的卷标为 `MYUD` 或者 `其他名称`：关闭自动挂载U盘
 - U盘的卷标为 `MYUD2017`：2017年，全年开启自动挂载U盘
 - U盘的卷标为 `MYUD1010`：10月10日，当天开启自动挂载U盘（注意：`系统时间是否正确`）

拔出U盘后，当挂载目录 `/mnt/MYUD1010` 空闲时，将自动卸载U盘，并删除挂载目录。

## 手动安装 CentOS-7.4-x86_64

**1. 开始安装：**

 - 开机从U盘启动
 - 依次执行：

    \[10] 启动自定义ISO/IMG文件（LMT目录）

    [02] 自动搜索并列出LMT目录下所有文件

    [03] RUN CentOS-7-x86_64-NetInstall-1708.iso

 - 选中 Test this media & install CentOS 7 并按下 `Tab` 键
 - 将内容修改为 `vmlinuz initrd=initrd.img inst.stage2=hd:/dev/sdb1 quiet inst.gpt`
 - 设置日期和时间，键盘，语言支持，安装位置等选项
 - 等待安装完成并重启

**2. 配置网络：**

 - 如果网卡驱动默认已经安装
 - 挂载U盘，例如 `fdisk -l; mount -t vfat /dev/sdb1 /mnt`
 - 运行 `config_network.sh`，例如 `/mnt/config_network.sh`


  [1]: https://github.com/myud/myud#%E9%87%8D%E8%A6%81%E8%AF%B4%E6%98%8E
  [2]: https://github.com/myud/myud#%E5%AE%89%E8%A3%85-myud
  [3]: https://github.com/myud/myud#%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85-centos-74-x86_64
  [4]: https://github.com/myud/myud#%E6%89%8B%E5%8A%A8%E5%AE%89%E8%A3%85-centos-74-x86_64
  [5]: https://github.com/myud/docs
  [6]: http://down.laomaotao.net:90/lmt816.exe
  [7]: https://gitee.com/mydownload/myud-installer/raw/master/Myud.exe