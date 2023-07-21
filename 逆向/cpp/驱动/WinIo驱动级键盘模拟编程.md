WinIo驱动级键盘模拟编程

201-02-02 14:38 1721人阅读 评论(0) 收藏 举报

分类：

综合（33）

文章来源：http://blog.sina.com.cn/s/blog_455d7a320100v37.html

前天无聊，翻翻自己的兴趣项目文件夹，发现了这个放下很久的项目！那是大三时候的事了当时是

为了提高我魔兽三的按键速度，用了个叫移花接木的软件，把键盘的键位改了。的确是所帮助，但

这是共享软件，用40次就不能再用了除非注册。于是乎就有了做一个类似的软件出来，在网上搜索了

一把发现WinIo模拟按键是最可靠的了，就决定向这方向钻进去了。哎\...技术不够，了很久的技术

文章和代码也只是了解了一点，而且那时MFC技术还没到家根本做不出什么能用的东西来\..后来听个

兄弟说:反汇编破解。于是又试了下，然真的被我破解了！一直用到现在啊!haha。

想完当年了，正题！

要做到驱动级的模拟，那么就要像驱动那样直接对硬件芯片的数据读写！这才算牛B！

1.首先，说说这个WinIo到底是何物!

WinIO库允许在32位的Windows应用程序中直接对I/O端口和物理内存进行存取操作。通过使用一种

内核模式的设备驱动器和其它几种底层编程技巧，它绕过Windows系统的保护机制。

因为操作系统对一些存地址进行了保护，这不至于任何程序都能直接访问硬件地址或胡乱改动

系统的内存数据！而我的键盘的端口地址正正在这段地址以内，所以我们不能随便地访问到！

但用了WinIo库可以了！它提供了很大的帮助！（它是一个国外牛人写的这是他的主页

http://ww.internals.com/，似乎很久没更新的）

2.有工具了，我们要怎么去开工呢？

别急先看看原，耐心是必需的！先看看别人写的参考文章！

ps/2 键盘硬件概述



对于驱动来说，和键盘相关的最重的硬件是两个芯片。一个是 intel 8042

芯片，位于主板

上，CPU 通过 IO

端口直接和这个芯片通信获得按键的扫描码或者发送各种键盘命令。另一个是

intel 8048

芯片或者其兼容芯片，位于键盘中，这个芯片主要作用是从键盘的硬件中得到被按的键所

产生的扫描码，与 i8042 通信，控制键盘本身。

当键盘上有键被按下时，i8048 直接获得键盘硬件产生的扫描码。i8048

也负责键盘本身的控

制，比如点亮 LED 指示灯，熄灭 LED 指示灯。i8048 通过 ps/2 口和 i8042

通信，把得到的扫描码

传送给 i8042。CPU 通过读写端口，可以直接把 i8042 中的数据读入到 CPU

的寄存器中，或者把

CPU 寄存器中的数据写入 i8042 中。ps/2 口一共有 6 个引脚，可以拔下 ps/2

插头看一下，这 6

个引脚分别为，时钟，数据，电源地，电源+5V，还有2个引脚没有被用到。由于只有一个引脚传输

据，所以 ps/2 口上的数据传输是串行的。

下面几幅图是一个盘的内部，可以看到用来产生扫描码的按键矩阵( Key Martix

)，可以看到

键盘中的芯片（这不是i8048，是一个兼容的其他型号的芯片）。

详细的图见：http://jiurl.neas.NET/document/KbdDriver/JiurlKbd 1.htm

注意，i8042 并不一定在主板上单独出现，可能被整合在某一芯片中。

1.2 扫描码 ，Make Code ，Break Code ，Typematic

当键盘上有键被按下，松开，按住，键盘将产生扫描码( Scan Code

)，这些扫描码将被 i8048

直接得到。扫描码有两种，Make Code 和 Break

Code。当一个键被按下或按住时产生的是Make Code

，当一个键被松开产生的是 Beak Code。每个键被分配了唯一的 Make Code 和

Break Code ，这样

主机通过扫描码可以知道是哪一个键。简单的说就是按下键，产生一个 Make

Code。松开，产生

一个 Brea Code。

而对于按住不放情况呢。我们可以打开一个记事本，把 \'a\'

键按住不放，可看到会不停的产

生 \'a\'直到我们松开。这是由于，当按住一个键不放时，将会 Typematic

，也就是自动打。每一

定时间，自动产一个被按住的键的 Make Code，直到最后松开该键。对于

Typematc 有两个重要的

参数，一个是 Typematic Delay ，决定了按下多长时间之后，进入

Typematc，另一个是 Typematic

Rate，决定在进入 Typematic 之后，一秒钟内能产生多少个 Make Code

。现在我们再打开事

本，按住 \'a\' 放，仔细观察，将看到第一个 \'a\' 和第二个 \'a\'

之间间隔的时间显比其他的要

长，而之后每个'a\'之间的时间间隔是一样的。



而对于同时按下个键的情况呢。在一个键被按下，产生了 Make

Code，而没有被松开，没有产

生 BreakCode 的时候，再按下另一个键，于是产生了另一个键的 Make Code

，就算是这两个键同

时按下。之，这两个键松开时，各自产生各自的 Break

Code。更多键的情况也是一样。比如要按

Ctrl 和 ，下面的情况就算作是同时按下了 Ctrl 和 A。按Ctrl，产生 Ctrl 的

Make Coe，然后按

A，产生 A  Make Code，然后各自松开，各自产生各自的 Break Code。

而对于按一个键放的时候，再按另一个键的情况呢。我们可以打开一个记事本，把\'a\'键按住不

放，不要松开，然后再按\'s\'键不放。我们可以看到当按下\'s\'时，\'a\'键并没有松，但是并没有\'a\'再

出现了，而是\'s\'始出现，这时即使松开了\'s\'，\'a\'也不会继续出现了。

1.3 扫描码集

到目前为止一共有套扫描码集( Scan Code Set )，ps/2

键盘默认使用第二。不过可以设置

i8042，让 8042 把得到的 Scan Code 翻译成 Scan Code Set 1 中的 Scan Code

，这样键盘驱动从

i8042 得到的有 Scan Code 都是第一套中的 Scan

Code（实际中驱动也是么做的）。所以我们只

讨论 Scan Code Set 1 。需要说明的是 Scan Code 和 ASCII码完全不相同。

在 Scan Cod Set 1 中，大多数键的 Make Code，Break Code

都是一个字节。他们的Make

Code 的最高位都0，也就是他们的 Make Code 都小于 0x7F。而他们的 Break

Code 为其 Mae

Code 或运算 8h ，也就是把 Make Code 的低7位不变，最高位设置为1。

还有一些扩展按键，他的 Scan Code

是双字节的。他们的一个字节都是E0h，表明这是一个

扩展键。第2个字节，和单字节 Sca Code 的情况相同。

还有一个特殊的键，Pause/Brak 键，它的 Make Code 为 E1,1D,45

E1,9D,C5，注意是 E1h 开

头。而且它没有 Break Cod 。

我们按键的 Make Code 的值的小，列出 Scan Code Set 1 中的所有扫描码

KEY MAKE BREAK

ESC 01 81

02 82



03 83

04 84

05 85

06 86

07 87

08 88

09 89

0A 8A

0B 8B

- 0C 8C

= 0D 8D

BKSP 0E 8E

TAB 0F 8F

Q 10 19

W 11 91

E 12 92

R 13 93

T 14 94



Y 15 95

U 16 96

I 17 97

O 18 98

P 19 99

\[ 1A 9A

\] 1B 9B

ENTER 1C 9C

L_CTRL 1D 9D

A 1E 9E

S 1F 9F

D 20 A0

F 21 A1

G 22 A2

H 23 A3

J 24 A4

K 25 A5



L 26 A6

; 27 A7

\' 28 A8

\` 29 89

L_SFT 2A AA

2B AB

Z 2 AC

X 2D AD

C 2 AE

V 2F AF

B 30 B0

N 31 B1

M 32 B2

, 33 B3

. 34 B4

/ 35 B5

R_SFT 36 B6

KP \* 37 B7



L_ALT 38 B8

SPACE 39 B9

CAPS 3A BA

F1 B BB

F2 3C BC

F3 D BD

F4 3E BE

F5 F BF

F6 40 C0

F7 41 C1

F8 42 C2

F9 3 C3

F10 44 C4

NUM 45 C5

SCRLL 46 C6

KP 7 47 C7

KP 8 48 C8



KP 9 49 C9

KP  4A CA

KP 4 4B CB

KP 5 4C CC

KP  4D CD

KP  4E CE

KP 1 4F CF

KP 2 0 D0

KP 3 51 D1

KP 0 52 D2

KP . 53 D3

F11 57 D7

F12 58 D8

KP EN E0,1C E0,9C

R_CTRL E0,1DE0,9D

KP / E0,35 E0,B5

R_ALT E0,38 E0,B8

HOME E0,47 E0,C7



UP ARROW E0,48 E0,C8

PG P E0,49 E0,C9

L ARROW E04B E0,CB

R ARROW E0,4D E0,CD

END E,4F E0,CF

D ARROW E,50 E0,D0

PG DN E051 E0,D1

INSERT E0,52 E0,D2

DELETE E0,53 E0,D3

L GUI E0,5B E,DB

R GUI E0,C E0,DC

APPS E0,5D E0,DD

PRNT SCRN E0,2A, E0,37 E0,B7, E0,AA

PAUSE E1,1D,45 E1,9DC5 -NONE

这里说几句对驱动没有帮助的题外话，记不清是由于先有了关于 Scan Cde

的值的猜测，才去按

这个顺序列 Scan Code ，还是先这样列 Scan Code ，才有了关于 Scan Code

的值的猜测。总之，用

这个 MakeCode

的顺序，和我们现在键盘上键的布局做对照我们大致就能猜到为什么 A 键的

Make

Code 值为 0x1e，为什么 H 键的 Make Code 值为

0x23。我们拿其中的一小段举例子，A 1E，S 1F，

D 20，F 21，G 22，H 23，看看键盘上 A,S,D,F,G,H

的位置吧。能感觉到些什么吧，感觉不到就算

了，这个和驱动是无关的。从 Scan Code Set

1，可能还能推测出来最早的键盘的样子。以及发生在键



盘上的一些变化。我们注意到 F10 和 F11,F12 的 Make Code

不是连在一起的，估计比较早的键盘只

有10个功能键，而不是现在的12个功能键。从键的 Make Code

来看，有可能曾经使用的一些键，现

在已经不出现在键盘上了。

还有一个值得注意的是，如果有 Make Code 为 0x60 的键，那么它的 Break Code

应该为

0x60+0x80=0xE0。那么这个键的 Break Code 将会和 表示扩展码的 0xE0

搞混。不过还好，并没有

Make Code 为 0x60 的键，所以不会发生搞混的况。 i8042 键盘控制器

键盘驱动直接读写 i8042 芯片，通过 8042 间接的向键盘中的 i8048

发命令。所以对于驱动来

说，直发生联系的只有 i8042 ，因此我们只介绍 i8042 ，不介绍 i8048。

象 i8042，i8048

这样的芯片，本身就是一个小的处理器，它的内部有自己的处理，有自己的

Ram，有自己的寄存器，等等。

i8042 有 4 个 8 bits 的寄存器，他们是 Status

Register（状态寄存器），Output Buffe（输出缓冲

器），Input Buffer（输入缓冲器），Control

Registr（控制寄存器）。使用两个 IO 端口，60h 和

64h。

Status Registe（状态寄存器）

状态寄存器是一个8位只读寄存器，任何时刻均可被cp读取。其各位定义如下

Bit7: PARITY-EVEN(P_E): 从键盘获得的数据奇偶校验错

Bit6: RCV-TMOUT(R_T): 接收超时，置1

Bit5: TRANS_TMOUT(T_T): 发送超时，置1

Bit4: KYBD_INH(K_I): 为1，键盘没有被禁止。0，键盘被禁止。

Bit3: CMD_DATA(C_D):

为1，输入缓冲器中的内容为命令，为0，输入缓冲器中的内容为数据。

Bit2: SYS_FLAG(S_F): 系统标志，加电启动置0，自检通过后置1

Bit1: INPUT_BUF_FULL(I_B_F): 输入缓冲器满置1，i8042 取走后置0



BitO: OUT_BUF_FULL(O_B_F): 输出缓冲器满置1，CPU读取后置0

Output Buffer（输出缓冲器）

输出缓冲器是一个8位只读寄存器。驱动从这个寄存器中读取数据。这些数据包括，扫描码，发往

i8042 命令的响应，间接的发往 i8048 命令的响应。

Input Buffer（输入缓冲器）

输入缓冲器是一个8位只写寄存器。缓冲驱动发来的内容。这些内容包括，发往

i8042 的命令，通

过 i8042 间接发往 i8048 的命令，以及作为命令参数的数据。

Control Register（控制寄存器）

也被称作 Controller Command Byte （控制器命令字节）。其各位定义如下

Bit7: 保留，应该为0

Bit6: 将第二套扫描码翻译为第一套

Bit5: 置1，禁止鼠标

Bit4: 置1，禁止键盘

Bit3: 置1，忽略状态寄存器中的 Bit4

Bit2: 设置状态寄存器中的 Bit2

Bit1: 置1，enable 鼠标中断

BitO: 置1，enable 键盘中断

2个端口 0x60,0x64

驱动中把 0x60 叫数据端口



驱动中把 0x64 叫命令端口

1.5 命令

驱动可以直接给 i8042 发命令，可以通过 i8042 间接给 i8048

发命令。命令这部分内容直接来自 \<

参考资料 \[1\] \>。

1.5.1 发给i8042的命令

驱动对键盘控制器发送命令是通过写端口64h实现的，共有12条命令，分别为

20h

准备读取8042芯片的Command Byte；其行为是将当前8042 Command

Byte的内容放置于Output

Register中，下一个从60H端口的读操作将会将其读取出来。

60h

准备写入8042芯片的Command Byte；下一个通过60h写入的字节将会被放入Command

Byte。

A4h

测试一下键盘密码是否被设置；测试结果放置在Output

Register，然后可以通过60h读取出来。测

试结果可以有两种值：FAh=密码被设置；F1h=没有密码。

A5h

设置键盘密码。其结果被按照顺序通过60h端口一个一个被放置在Input

Register中。密码的最后

是一个空字节（内容为0）。

A6h

让密码生效。在发布这个命令之前，必须首先使用A5h命令设置密码。



AAh

自检。诊断结果放置在Output Register中，可以通过60h读取。55h=OK。

ADh

禁止键盘接口。Command

Byte的bit-4被设置。当此命令被发布后，Keyboard将被禁止发送数据

到Output Register。

AEh

打开键盘接口。Command

Byte的bit-4被清除。当此命令被发布后，Keyboard将被允许发送数据

到Output Register。

C0h

准备读取Input Port。Input Port的内容被放置于Output

Register中，随后可以通过60h端口读取。

D0h

准备读取Outport端口。结果被放在Output

Register中，随后通过60h端口读取出来。

D1h

准备写Output端口。随后通过60h端口写入的字节，会被放置在Output Port中。

D2h

准备写数据到Output Register中。随后通过60h写入到Input

Register的字节会被放入到Output

Register中，此功能被用来模拟来自于Keyboard发送的数据。如果中断被允许，则会触发一个中断。

1.5.2 发给8048的命令

共有10条命令，分别为



EDh

设置LED。Keyboard收到此命令后，一个LED设置会话开始。Keyboard首先回复一个ACK

（FAh），然后等待从60h端口写入的LED设置字节，如果等到一个，则再次回复一个ACK，然后根据

此字节设置LED。然后接着等待。。。直到等到一个非LED设置字节(高位被设置)，此时LED设置会话

结束。

EEh

诊断Echo。此命令纯粹为了检测Keyboard是否正常，如果正常，当Keyboard收到此命令后，将会

回复一个EEh字节。

F0h

选择Scan code set。Keyboard系统共可能有3个Scan code

set。当Keyboard收到此命令后，将回

复一个ACK，然后等待一个来自于60h端口的Scan code

set代码。系统必须在此命令之后发送给

Keyboard一个Scan code

set代码。当Keyboard收到此代码后，将再次回复一个ACK，然后将Scan

code set设置为收到的Scan code set代码所要求的。

F2h

读取Keyboard

ID。由于8042芯片后不仅仅能够接Keyboard。此命令是为了读取8042后所接的设

备ID。设备ID为2个字节，Keyboard

ID为83ABh。当键盘收到此命令后，会首先回复一个ACK，然

后，将2字节的Keyboard ID一个一个回复回去。

F3h

设置Typematic

Rate/Delay。当Keyboard收到此命令后，将回复一个ACK。然后等待来自于60h的

设置字节。一旦收到，将回复一个ACK，然后将Keyboard

Rate/Delay设置为相应的值。

F4h

清理键盘的Output Buffer。一旦Keyboard收到此命令，将会将Output

buffer清空，然后回复一个

ACK。然后继续接受Keyboard的击键。



F5h

设置默认状态(w/Disable)。一旦Keyboard收到此命令，将会将Keyboard完全初始化成默认状态。

之前所有对它的设置都将失效\--Output buffer被清空，Typematic

Rate/Delay被设置成默认值。然后回

复一个ACK，接着等待下一个命令。需要注意的是，这个命令被执行后，键盘的击键接受是禁止的。

如果想让键盘接受击键输入，必须Enable Keyboard。

F6h

设置默认状态。和F5命令唯一不同的是，当此命令被执行之后，键盘的击键接收是允许的。

FEh

Resend。如果Keyboard收到此命令，则必须将刚才发送到8042 Output

Register中的数据重新发

送一遍。当系统检测到一个来自于Keyboard的错误之后，可以使用自命令让Keyboard重新发送刚才发

送的字节。

FFh

Reset

Keyboard。如果Keyboard收到此命令，则首先回复一个ACK，然后启动自身的Reset程

序，并进行自身基本正确性检测（BAT-Basic Assurance

Test）。等这一切结束之后，将返回给系统一

个单字节的结束码（AAh=Success, FCh=Failed），并将键盘的Scan code

set设置为2。

1.5.3 读到的数据

00h/FFh

当击键或释放键时检测到错误时，则在Output Bufer后放入此字节，如果Output

Buffer已满，则会

将Output Buffer的最后一个字节替代为此字节。使用Scan code set

1时使用00h，Scan code 2和Scan

Code 3使用FFh。

AAh

BAT完成代码。如果键盘检测成功，则会将此字节发送到8042 Output

Register中。

EEh



Echo响应。Keyboard使用EEh响应从60h发来的Echo请求。

F0h

在Scan code set 2和Scan code set 3中，被用作Break Code的前缀。

FAh

ACK。当Keyboard任何时候收到一个来自于60h端口的合法命令或合法数据之后，都回复一个

FAh。

FCh

BAT失败代码。如果键盘检测失败，则会将此字节发送到8042 Output

Register中。

FEh

Resend。当Keyboard任何时候收到一个来自于60h端口的非法命令或非法数据之后，或者数据的

奇偶交验错误，都回复一个FEh，要求系统重新发送相关命令或数据。

83ABh

当键盘收到一个来自于60h的F2h命令之后，会依次回复83h，ABh。83AB是键盘的ID。

Scan code

除了上述那些特殊字节以外，剩下的都是Scan code。

1.6 端口操作

首先介绍一下端口的读写操作，驱动中使用函数 READ_PORT_UCHAR 进行读操作，

READ_PORT_UCHAR 中使用CPU读端口指令，in。驱动中使用函数 WRITE_PORT_UCHAR

进行写

操作，WRITE_PORT_UCHAR 中使用CPU写端口指令，out。



1.6.1 读取状态寄存器

读取状态寄存器的方法，对64h端口进行读操作。

1.6.2 读数据

需要读取的数据有，i8042从i8048得到的按键的扫描码，i8042命令的ACK，i8042从i8048得到的

i8048命令的ACK，需要命令重发的RESEND，一些需要返回结果的命令得到的结果。

当有数据需要被驱动读走的时候，数据被放入输出缓冲器，同时将状态寄存器的bit0

（OUTPUT_BUFFER_FULL）置1，引发键盘中断（键盘中断的IRQ为1）。由于键盘中断，引起由键

盘驱动提供的键盘中断服务例程被执行。在键盘中断服务例程中，驱动会从i8042读走数据。一旦数据

读取完成，状态寄存器的bit0会被清0。

读数据的方法，首先，读取状态寄存器，判断bit0，状态寄存器bit0为1，说明输出缓冲器中有数

据。保证状态寄存器bit0为1，然后对60h端口进行读操作，读取数据。

这里我们要谈一点很有用的题外话，前面提到的 IRQ，是 Interrupt Request

line，中断请求线，

是一个硬件线，它和中断向量是不同的。中断向量是用来在中断描述符表(IDT)中查找中断服务例程的

那个序号。键盘的 IRQ

是1，键盘中断服务例程对应的中断向量可不是1。这点要弄清楚。

1.6.3 向i8042发命令

当命令被发往i8042的时候，命令被放入输入缓冲器，同时引起状态寄存器的 Bit1

置1，表示输入

缓冲器满，同时引起状态寄存器的 Bit2

置1，表示写入输入缓冲器的是一个命令。

向i8042发命令的方法，首先，读取状态寄存器，判断bit1，状态寄存器bit1为0，说明输入缓冲器

为空，可以写入。保证状态寄存器bit1为0，然后对64h端口进行写操作，写入命令。

1.6.4 间接向i8048发命令

向i8042发这些命令，i8042会转发i8048，命令被放入输入缓冲器，同时引起状态寄存器的Bit1

置

1，表示输入缓冲器满，同时引起状态寄存器的 Bit2

置1，表示写入输入缓冲器的是一个命令。这里我

们要注意，向i8048发命令，是通过写60h端口，而后面发命令的参数，也是写60h端口。i8042如何判

断输入缓冲器中的内容是命令还是参数呢，我们在后面发命令的参数中一起讨论。



向i8048发命令的方法，首先，读取状态寄存器，判断bit1,状态寄存器bit1为0，说明输入缓冲器为

空，可以写入。保证状态寄存器bit1为0，然后对60h端口进行写操作，写入命令。（注意呢！）

1.6.5 发命令的参数

某些命令需要参数，我们在发送命令之后，发送它的参数，参数被放入输入缓冲器，同时引起状

态寄存器的Bit1

置1，表示输入缓冲器满。这里我们要注意，向i8048发命令，是通过写60h端口，发命

令的参数，也是写60h端口。i8042如何判断输入缓冲器中的内容是命令还是参数呢。i8042是这样判断

的，如果当前状态寄存器的Bit3

为1，表示之前已经写入了一个命令，那么现在通过写60h端口放入输

入缓冲器中的内容，就被当做之前命令的参数，并且引起状态寄存器的 Bit3

置0。如果当前状态寄存器

的 Bit3

为0，表示之前没有写入命令，那么现在通过写60h端口放入输入缓冲器中的内容，就被当做一

个间接发往i8048的命令，并且引起状态寄存器的 Bit3 置1。

向i8048发参数的方法，首先，读取状态寄存器，判断bit1,状态寄存器bit1为0，说明输入缓冲器为

空，可以写入。保证状态寄存器bit1为0，然后对60h端口进行写操作，写入参数。（同上面红字所说一

样）

\"1 ps/2 键盘的硬件\" 主要参考下面的资料，关于 ps/2

键盘硬件更多的内容也请参考下面的资料

\[1\] http://pagoda-ooos.51.Net/os_book/driver/driver-ke yboard_2.htm

（中文）

\[2\] http://panda.cs.ndsu.nodak.edu/\~achapwes/PICmicro/ PS2.pdf

（中文）

\[3\] http://panda.cs.ndsu.nodak.edu/\~achapwes/PICmicro/ （英文）

下面是我的代码，用来每隔一秒就虚拟一个ctrl+a的操作。

// HDkey.cpp : 定义控制台应用程序的入口点。

//

#include \"stdafx.h\"

#include \"windows.h\"

#include

\"winio.h\"//程序要运行时要包含winio.dll和winio.sys(NT系统下);winio.dll和winio.vxd(98系统

下);

#include \"time.h\"



#define key_cmd 0x64//键盘命令端口

#define key_dat 0x60//键盘数据端口

//等待缓冲区为空

void KBCwait4IBE() {

DWORD ch=0;

//注意，在这循环，我并没有改变键盘命令端口的数据，但也不会出现死循环，/

因

为键盘中断会在中间把数据读取并置零，那就不会导致死循环了

do { GetPortVal(key_cmd,&ch,1);//读取键盘的命令端口，得出ch

} while(ch & 0x2);//bit1是1的话，说明输入缓冲器已满，反复检测！直到空

}

//键 按下

void MakeKeyDown(DWORD VirtualKey) {

DWORD K_Make_Code=MapVirtualKey(VirtualKey,0);//winuser.

h里面定义好的函数！

KBCwait4IBE();

SetPortVal(key_cmd,0xd2,1);//d2是说，准备写数据到Output

Register中。随后通过60h写入到Input

Register的字节会被放入到Output

Register中，此功能被用来模拟来自于Keyboard发送的数据。如果

中断被允许，则会触发一个中断处理。（具体看原理文档）

SetPortVal(key_dat,K_Make_Code,1); } //

键 放开 void MakeKeyUp(DWORD VirtualKey) { DWORD

K_Make_Code=MapVirtualKey(VirtualKey,0);//键的扫描码 DWORD

K_Break_Code=K_Make_Code+0x80;//键的断码 KBCwait4IBE();

SetPortVal(key_cmd,0xd2,1);//d2是

说，准备写数据到Output Register中。随后通过60h写入到Input

Register的字节会被放入到Output

Register中，此功能被用来模拟来自于Keyboard发送的数据。如果中断被允许，则会触发一个中断处

理。（具体看原理文档） SetPortVal(key_dat,K_Break_Code,1); } void main()

{ bool Intial;

Intial=InitializeWinIo(); while(1) { MakeKeyDown(VK_CONTROL);

MakeKeyDown(\'A\');

MakeKeyUp(\'A\'); MakeKeyUp(VK_CONTROL); Sleep(1000); } ShutdownWinIo();

}

其实也挺简单的，最难还是在于理解键盘是怎样产生一个按键消息的原理，要非常耐心地看！和多参

考别人的实现方法！

这个WinIo很牛B啊！如果用来做外挂应该很爽！

