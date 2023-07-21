win7 x64驱动开发经验（三）windbg 双机调试配置 、问题及解决办法

\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

转自http://yexin218.teye.com/blog/545187

VMware+Windgb+Win7内核驱动调试

本人在此基础之上根据具体情况有所改动

\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

本文主要记录个安装VMware+Windgb+Win7内核驱动调试的笔记。

一、安装环境

主机：Windows 7 x64 En U 版

虚拟机：VMware 7.1.4 VM8.0.2 (亲测)

GUestOS(虚拟机): Win7 64 chs U 版

Windbg: 最新

二、虚拟机配置

1. 打开相应 vmware 虚拟机上的 "Virtaul Machine Settings"

a. "Hardware "选项中 \-\-\--\> 点击"Add\" 添加一个串口设备 SeriallPort .



a\. \"Next\",在 \"Serial Prt\" 里选中 "Output to named pipe\"

a. \"next\",然后如下设置：



1\. 确定之后回到如下界面，在右脚\"Virtual Machine Settings\"

页面时，在"I/O Mode" 里选中

"Yied CPU on poll"



2\. Ok之后就设定完毕了。

三、Windbg设置

下载地址： Windbg

安装之后，设置一个桌面快捷方式，然后，右-\>属性，在Target中的引号后面添加如下：-b

-

k com:pipe,port=\\\.\\pipe\\com_1,resets=0



或者是： -b -k com:port=\\\\.\\pipe\\com_1,baud=115200,pipe

【二者似乎皆可】

四、GuestOS设置 （就是虚拟机里的系统配置）

适用于win7 vistar 如果感觉黑窗口玩不了 请看7. 这种方法更直观

1. 在administrator权限下, 进入command line模式, 键入bcdedit命令,

会出现以下界面:



2\. 然后, 设置端口COM1, baudrate为115200 (除COM1外, 也可以用1394或USB.

1394用起来比

COM口快多了, 当然前提是你需要有1394卡及其驱动.

很恶心的是Vista不再支持1394的文件传

输协议, 但是用windbg双机调试还是可以的)

命令为:

bcedit /dbgsettings {serial \[baudrate:value\]\[debugport:value\] \|

1394 \[channel:value\] \| usb }

3. 接着, 我们需要复制一个开机选项, 以进入OS的debug模式

命令为:



bcdedit /copy {current} /dDebugEnty

DebugPoint为选项名称, 名字可以自己定义. 然后复制得到的ID号.

4. 接着增加一个新的选项到引导菜

bcdedit /displayorder {current} {ID}

这里的{ID}的ID值是刚生成的ID值.

5. 激活DEBUG : bcdedit /debug {ID} ON



这里的{ID} 的ID值还是刚才的ID值.

6. 命令执行成功, 重新启动机器.

7. 7.或者更简的图形界面设置：在msconfig界面中，选Boot,再选Advanced

options，在选择

Debug、Debug port、Bud rate都打上钩。如果所示：

8.

选择DebugEntry\[debug\]作为等入口。启动后，打开windbg.可以看到类似如下的信息：



a\. Micrsoft (R) Windows Debugger Version 6.11.0001.404 X86

b. Copyright (c) Microsoft Corporatin. All rights reserved.

c.

d. Opened \\\\.\\pipe\\com_1

e. Waiting to reconnect\...

f. Connected to Windows 7 7600 x86 compatble target at (Thu Dec 10

17:46:36.928 2009 GMT+8)),

ptr64 FALSE

g. Kernel Deugger connection established. (Initial Breakpoint

requesed)

h. Symbol search path is: \*\*\* Invalid \*\*\*

i.

\*\*\**\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

j. \* ymbol loading may be unreliable without a symbol search path. \*

k. \* Use .ymfix to have the debugger choose a symbol path. \*

l. \* After settng your symbol path, use .reload to refresh symbol

locations. \*

m.

\*\*\*\*\*\\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

n. Executable search path is:

o.

\*\*\\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

p. \* Symbols can not be loaded because symbol path is not initialized.

\*

q. \* \*

r. \* The Symbol Path can be set by: \*

s. \* using the \_NT_SYMBOL_PATH environment variable. \*

t. \* using the -y \<symbol_path\> argument when starting the debugger.

\*

u. \* using .sympath and .sympath+ \*

v.

\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

w. \*\*\* ERROR: Symbol file could not be found. Defaulted to export

symbols for ntkrpamp.exe -

x. Windows 7 Kernel Version 7600 MP (1 procs) Free x86 compatible

y. Product: WinNt, suite: TerminalServer SingleUserTS

z. Built by: 7600.16385.x86fre.win7_rtm.090713-1255

aa. Machine Name:

ab. Kernel base = 0x83e0f000 PsLoadedModuleList = 0x83f57810

ac. Debug session time: Thu Dec 10 17:46:32.658 2009 (GMT+8)

ad. System Uptime: 0 days 0:06:18.429

ae. Break instruction exception - code 80000003 (first chance)

af.

\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

ag. \* \*

ah. \* You are seeing this message because you pressed either \*

ai. \* CTRL+C (if you run kd.exe) or, \*

aj. \* CTRL+BREAK (if you run WinDBG), \*

ak. \* on your debugger machine\'s keyboard. \*

al. \* \*

am. \* THIS IS NOT A BUG OR A SYSTEM CRASH \*

an. \* \*

ao. \* If you did not intend to break into the debugger, press the \"g\"

key, then \*

ap. \* press the \"Enter\" key now. This message might immediately

reappear. If it \*

aq. \* does, press \"g\" and \"Enter\" again. \*

ar. \* \*

as.

\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

at. nt!DbgBreakPointWithStatus+0x4:

au. 83e7a394 cc int 3



五、操作方式提示

我发现，如果在GuestOs

-win7启动过程中，如果打开了windbg之后，整个系统就像死机，不动

了。估计是windbg启动后设定了断点做调试，试试按F5,或者go这样就可以恢复原来的状态

\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--问题及解决办法\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Windows7 x64 + VMware + WinDbg 双机调试故障解决

源于：

http://blog.tianya.cn/blogger/post_read.asp?BlogID=1439846&PostID=38575768

作者:MuseHero 2012-02-07 09:37 星期二 晴

最近对虚拟机及里面的OS都进行了升级，在配置Windbg双机调试时，出现两个问题。

在网上搜了搜，第二个问题几乎没有参考资料，就在国外看到过一例出同样问题的，现把解决方

法放出来，供有同样麻烦的朋友们参考：

第一个问题：

现像：打开虚拟机后无法连接，提试无法打开连接端口。

故障原因：WMWare7.x及以后的版本在添加Serial Port时默认为Serial

Port2，即COM2端

口，而习惯了用WMWare6.x的朋友们升级7.x时习惯了按旧有设置（COM1）来进行双机调试，就会

连接不上了。

解决方案：

1、在添加Serial

Port时将虚拟机硬件配置中的打印机删除，再创建SerialPort时就是

SerialPort1了，其它不用改变，直接可以按原有方式进行双调试的设置。

2、虚拟的硬件设置不变，在虚拟OS中添加调试引导项时（bcdedit里），把端口设为COM2，

也是可行的。

以上两个方案任选其一可解决。

第二个问题：

现像：在虚拟OS开机引导，加载完ClassPnp驱动后，实机中的WinDbg强制关闭（就是窗口突

然没了，进程也结束了）

故障原因：调试WinDbg时显示故障是"调试目标初始化时出现问题，错误码：0x8000FFFF"。

（现在我也没搞明白这是啥子故障）

解决方案：

这个故障是在引导过程中发生的，通过排除发现不加载网络驱动则不会出现故障，所以解决方案

也就很简单了，在虚拟硬件设置中把网络连接中的"开机连接"去掉，让开机时不连接网络。

进入虚拟OS后，如果需要使用网络，再手动连接网络，经测试开机后手动连接不会触发故障出现。

第二个问题用笨方法解决了，但原理没有搞清楚，应该是跟虚拟网络有关，有明白原因的朋友还

请告诉一下子，谢谢了。

（后注：用了几天后发现第二个问题的解决方案并不稳定，时好时坏，最后不得不换装Windows7家

庭版解决，经测试VMWare里面装Windows7

64位旗舰版时会出这个问题，装家庭版未发现有同样的

问题。）



友情提示：

在设置双机调试时，总是记不住bcdedit的命令，后来才知道用msconfig就可以直接在图形界面设置

了，同样记忆力差的朋友可以尝试一下子。

