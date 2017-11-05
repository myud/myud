# Myud (My UDisk)

内容目录：

 - [重要说明][1]
 - [安装 Myud][2]
 - 手动安装 CentOS-7.4-x86_64
 - [相关文档][3]

## 重要说明

硬件要求：

 - 仅支持一块 500G 以上的 SATA 硬盘
 - 需要一个 4G 以上的U盘
 - 需要 CentOS 将硬盘识别为 `sda`，将U盘识别为 `sdb`

## 安装 Myud

 - 请下载 [老毛桃U盘启动盘制作工具][4] 及 [Myud.exe][5]
 - 先使用 老毛桃U盘启动盘制作工具 将U盘制作成 `启动U盘`
 - 然后把 Myud.exe 拷贝到U盘 `根目录` 下运行

## 手动安装 CentOS-7.4-x86_64

**开始安装：**

 - 开机从U盘启动
 - 依次执行：

    \[10] 启动自定义ISO/IMG文件（LMT目录）

    [02] 自动搜索并列出LMT目录下所有文件

    [03] RUN CentOS-7-x86_64-NetInstall-1708.iso

 - 选中 Test this media & install CentOS 7 并按下 `Tab` 键
 - 将内容修改为 `vmlinuz initrd=initrd.img inst.stage2=hd:/dev/sdb1 quiet inst.gpt`
 - 设置日期和时间，键盘，语言支持，安装位置等选项
 - 等待安装完成并重启

**配置网络：**

 - 如果网卡驱动默认已经安装
 - 挂载U盘，例如 `fdisk -l; mount -t vfat /dev/sdb1 /mnt`
 - 运行 `config_network.sh`，例如 `/mnt/config_network.sh`








  [1]: https://github.com/myud/myud#%E9%87%8D%E8%A6%81%E8%AF%B4%E6%98%8E
  [2]: https://github.com/myud/myud#%E5%AE%89%E8%A3%85-myud
  [3]: https://github.com/myud/docs
  [4]: http://down.laomaotao.net:90/lmt816.exe
  [5]: https://gitee.com/mydownload/myud-installer/raw/master/Myud.exe