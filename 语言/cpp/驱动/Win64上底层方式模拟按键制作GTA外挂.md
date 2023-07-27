Win64上底层方式模拟按键制作GTA外挂

2011-12-12 23:09:38

标签：游戏 解决方案 按键 DirectX 侠盗猎车

问题由来

我比较喜欢玩《侠盗猎车：自由城之章》（简称《GTA:EFLC》）。不过本人玩游戏水平

比较菜，经常被游戏里的贼和警狂虐，心里十分不爽，而网上下载的外挂不是有病毒就是

不能用，游戏内置的作弊器操作很麻烦，于是萌生了自己做一个外挂的想法。在游戏里，只

要输入一个十位数的作弊码就能进行一系列的作弊，比如补全生命，获得武器，修复汽车等。

但由于要输入10个毫无规律的数字，让人很是抓狂。而且在进行这一系列操作时，往往还

必须进行其它操作，比如驾车、枪战。往往一个不小心，就GameOver了。利用模拟按键的

方式输入，能节省宝贵的时间。

解决方案

因为《GTA:EFLC》是

DirectX游戏，所以一切use32.dll提供的模拟按键函数（如

SendInput之流）都失效了，因为DirectX游戏是利用DirectIput绕过Windows的消息机

制直接和硬件交道来接收按键信息的。因此，我们必须使用驱动级别的模拟按键。但是在

驱动里如何进行模拟按键，我全然不知，一时我的研究就陷入的僵局。后来偶然得知了WinIO

这个神器，于是开始了我的研究历程。

WinIO是一款免费、开源的系统组件，你可以在www.internals.com面免费下载它的

源码。在最新版本3.0中，增加了对64位

Windows操系统的支持。我就是利用它的功能，

实现了驱动级模拟按键。在我使的WinIO 3.0中，里面有四个bin 文件，分别是

WinIO32.dll、WinO64.dll、WinIO32.sys、WinIO64.sys。sys文件是实现核心功能的驱动，

dll文件是封装驱动能的接口。由于我的系统是64

位系统，使用了VB做界面编程，所以

仅需要 WinIO32.dll和 WinIO64.ss。dll 文件有 10

个导出函数。在我的模拟按键程序里

仅需用到四个：InitializeWinIo、ShutdownWinIo、GetPortVal、SetPortVal。

说到驱动模拟按键，其实就是读写端口。说到读写端，其实学过16位汇编的人都知

道，用 IN、OUT指令即可。不过可别忘记了，IN、OUT 指令属于特权指令，所以在

Ring 3

下不能调用，必须在驱动里调用。不过WinIO的作者并没有用内联汇编的方法实现读写IO

端口，而是使用了档化的READ_PORT_UCHAR、READ_PORT_USHORT、READ_PORT_ULONG、

WRITE_PORT_UCHAR、WRITE_PORT_USHORT、WRITE_POT_ULONG函数来实现。个人认为内联汇

编是一个不好的习惯，因为这样使代码有了很强的平台限制性。网上一些所谓的高手特别喜

欢在代码里内联汇编，以显示所谓的"高手风范"。其实恰恰相反，我在学驱动初期就特别

喜欢在驱动代码里内联汇编模仿高手"，现在到是能不内联汇编就不内联汇编，以提高代

码的通用程度。

言归正传，我们要用到的四个函数原型和功能如下：

bool \_stdcall InitializeWinIo(); This funcion initializes the WinIo

library.

void \_stdcall ShutdownWiIo(); This function performs cleanup of the

WinIo library.

bool \_stdcall GePortVal(

WORD wPortAddr,

PDWORD pdwPortVal,

BYTE bize

);

This function reads a BYTE/WORD/DWORD

value from an I/O port.

bool \_tdcall SetPortVal(

WORD wPortAddr,

DWORD dwPortVal,

BYTE bSize

);

Ths function writes a BYTE/WORD/DWORDvalue to an I/O port.

根据 VB 和C代码的互换规则，得到以下声明：

Public Declare unction InitializeWinIo Lib \"WinIo.dll\" () As Boolean

Public Decare Function ShutdownWinIo Lib \"WinIo.dll\" () As Boolean

Public Declare Function GetPortVal Lib \"WinIo.dll\" (ByValPortAddr As

Integer,



ByRef PortVal As Long, ByVal bSize As Byte) As Boolean

Public Dclare Function SetPortVal Lib \"WinIo.dll\" (ByVal PortAddr As

Integer,

问题由来

我比较喜欢玩《侠盗猎车：自由城之章》（简称《GTA:EFLC》）。不过本人玩游戏的水平

比较，经常被游戏里的贼和警察狂虐，心里十分不爽，而网上下载的外挂不是有病毒就是

不能用，游戏内置的作弊器操作很麻烦，于是萌生了自己做个外挂的想法。在游戏里，只

要输入一个十位数的作弊码就能进行一系列的作弊，比如补全生命，获得武器，修复汽车等。

但由于要输入10个毫无规律的数字，让人很是抓狂。而且在进行这一列操作时，往往还

必须进行其它操作，比如驾车、枪战。往往一个不小心，就GameOver了。利用模拟按键的

方式输入，能节省宝贵的间。

解决方案

因为《GTA:FLC》是

DirectX游戏，所以一切user32.dll提供的模拟按键函数（如

SendInput之流）都失效了，因为DirectX游戏是利用DirectInput绕过Windows的消息机

制直接和硬件打交道来接收按键信息的。因此我们必须使用驱动级别的模拟按键。但是在

驱动里如何进行模拟按键，我全然不知，一时的研究就陷入的僵局。后来偶然得知了WinIO

这个神器，于是开了我的研究历程。

WinIO是一款费、开源的系统组件，你可以在www.jybase.net下载它的

源码。在最新版本3.0中，增加了对64位

Windows操作系统的支持。我就是利用的功能，

实现了驱动级模拟按键。在我使用的WinIO 3.0中，里面有四个bin 文件，分别是

WinIO32.dll、WinIO64dll、WinIO32.sys、WinIO64.sys。sys文件是实现核心功能的驱动，

dll文件是封装驱动功能的接口。由于我的系统是64

位系统，使用了VB做界面编程，所以

仅需要 WinIO32.dll和 WiIO64.sys。dll 文件有 10

个导出函数。在我的模拟按键程序里，

仅需要用到四个：IniializeWinIo、ShutdownWinIo、GetPortVal、SetPortVal。

说到驱动模拟按键，其实就是读写端口。说到读写端口，其实学过6位汇编的人都知

道，用 IN、OUT指令即可。不过可别忘记了，IN、OUT 指令属于特权指令所以在

Ring 3

下不能调用，须在驱动里调用。不过WinIO的作者并没有用内联汇编的方法实现读写IO

端口，而是使用了文档化的READ_PORT_UCHA、READ_PORT_USHORT、READ_PORT_ULONG、

WRITE_PORT_UCHAR、WRIT_PORT_USHORT、WRITE_PORT_ULONG函数来实现。个人认为内联汇

编是一个不好的习惯，因为这样使代码有了很强的平台限制性。网上一些所谓的高手特别喜

欢在代码里内联汇编，以显示所谓的"高手风范"。其实恰恰相反，我在学驱动初期就特别

喜欢在驱动代码里内联汇编模仿"高手"，现在到是能不内联汇编就不内联汇编，以提高代



码的通用程度。

言归正传，我们要用到的四个函数原型和功能如下：

bool \_stdcall InitializeWinIo(); This function initializes the WinIo

library.

void \_stdcall ShutdownWinIo(); This function performs cleanup of the

WinIo library.

bool \_stdcall GetPortVal(

WORD wPortAddr,

PDWORD pdwPortVal,

BYTE bSize

);

This function reads a BYTE/WORD/DWORD

value from an I/O port.

bool \_stdcall SetPortVal(

WORD wPortAddr,

DWORD dwPortVal,

BYTE bSize

);

This function writes a BYTE/WORD/DWORDvalue to an I/O port.

根据 VB 和C代码的互换规则，得到以下声明：

Public Declare Function InitializeWinIo Lib \"WinIo.dll\" () As Boolean

Public Declare Function ShutdownWinIo Lib \"WinIo.dll\" () As Boolean

Public Declare Function GetPortVal Lib \"WinIo.dll\" (ByVal PortAddr As

Integer,

ByRef PortVal As Long, ByVal bSize As Byte) As Boolean

Public Declare Function SetPortVal Lib \"WinIo.dll\" (ByVal PortAddr As

Integer,

ByVal PortVal As Long, ByVal bSize As Byte) As Boolean

以下代码实现了模拟按键：

Public Const KBC_KEY_CMD = &H64

Public Const KBC_KEY_DATA = &H60

Public Sub KBCWait4IBE()



Dim dwVal As Long

Do

GetPortVal KBC_KEY_CMD, dwVal, 1

Loop While (dwVal And &H2)

End Sub

Public Sub MyKeyDown(ByVal vKeyCode As Long)

KBCWait4IBE

SetPortVal KBC_KEY_CMD, &HD2, 1

KBCWait4IBE

SetPortVal KBC_KEY_DATA, MapVirtualKey(vKeyCode, 0), 1

Sleep 100

KBCWait4IBE

SetPortVal KBC_KEY_CMD, &HD2, 1

KBCWait4IBE

SetPortVal KBC_KEY_DATA, (MapVirtualKey(vKeyCode, 0) Or &H80), 1

End Sub

比如我要模拟按下小键盘上的0，仅需要以下代码：MyKeyDown VK_NUMPAD0。其中

VK_NUMPAD0是小键盘上0的虚拟键码，这些虚拟键码在winuser.h里有定义。不过不能连

续按下两个相同的键，如果连续按下两个相同的键，会出现只有一个按下的效果。在按下两

个相同的键时，要等待上50

毫秒。比如实现补血的作弊码是3625550100，那么代码这么写：

MyKeyDown VK_NUMPAD3

MyKeyDown VK_NUMPAD6

MyKeyDown VK_NUMPAD2

MyKeyDown VK_NUMPAD5

Sleep 50

MyKeyDown VK_NUMPAD5

Sleep 50

MyKeyDown VK_NUMPAD5

MyKeyDown VK_NUMPAD0

MyKeyDown VK_NUMPAD1

MyKeyDown VK_NUMPAD0

Sleep 50



MyKeyDown VK_NUMPAD0

MyKeyDown VK_RETURN

需要说明的是，WinIO64.sys没有正式的数字签名，只有测试签名。要使它能成功加载，

必须打开测试模式（cmd里切换到 system32目录再输入 bcdedit /set

testsigning on），

然后根据以下步骤信任WinIO64.sys的测试签名：

1.打开 WinIO64.sys的属性框，翻到"数字签名"选项卡，点击"详细信息"

2.在新出来的对话框中点击"查看证书"

3.在又新出来的对话框中点击"安装证书"

4.点击"下一步"，然后选择"将所有的证书放入下列存储"

5.点击浏览，选择"受信任的根证书发布机构"

受信任的根证书发布界面

6.点击"下一步"，然后点击"完成"

7.在弹出的"安全性警告"对话框中选择"是"，才能导入成功

效果测试

在我的那个外挂中，除了驱动模拟按键，还有注册热键等代码，因为这个和本文主题无

关，所以就略过不表了。最终实现的效果就是在游戏中按下F1到F6

六个键，实现了六个作

弊功能。要进行测试很简单，先运行我的程序，再打开记事本，分别按下F1至

F6，就能输

入六串数字。当然也可以随便申请一个QQ

号，密码设置为3625550100，然后把光标放到密

码框里，按下F1，就会能自动登录了（QQ

的密码框防止了普通方式的模拟按键，一般来说

需要用驱动模拟按键）。

