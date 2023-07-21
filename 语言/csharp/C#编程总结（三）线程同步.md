C#编程总结（三）线程同步

在应用程序中使用多个线程的一个好处是每个线程可以异步执行。对于 Windows

应用程序，耗时的任务可以在后台执行，而使应用

程序窗口和控件保持响应。对于服务器应用程序，多线程处理提供用不同线程处理每个传入请求的能力。否则，在完全满足前一个请

求之前，将无法处理每个新请求。然而，线程的异步特意味着必须协调对资源（如文件句柄、网络连接和内存）的访问。否则，两个

或更多的线程可能在同一时间访问相同的资源，而每个线程都不知道其他线程的操作。

\"如果觉得有用，请帮顶! 如果有不足之处，欢迎拍砖!\"

线程同步的方式

线程同步有：临界区、互斥区、事件、信号量四种方式

临界区（Critical

Section）、互斥（Mutex）、信号量（Semaphore）、事件（Event）的区别

1、临界区：通过对多线程的行化来访问公共资源或一段代码，速度快，适合控制数据访问。在任意时刻只允许一个线程对共享资

源进行访问，如果有多个线程试图访问公共资源，那么在有一个线程进入后，其他试图访问公共资源的线程将被挂起，并一直等到进入

临界区的线程离开，临界区在被释放后，其他线程才可以抢占。

2、互斥量：采用互斥对机制。

只有拥有互斥对象的线程才有访问公共资源的权限因为互斥对象只有一个，所以能保证公共资

源不会同时被多个线程访问。互斥不仅能现同一应用程序的公共资源安全共享，还能实现不同应用程序的公共资源安全共享

3、信号量：它允许多个线程同一时刻访问同一资源，但是需要限制在同一时刻访问此资源的最大线程数目

4、事 件：

通过通知操作的方式来保持线程的同步，还可以方便实现对多个线程的优先级比较的操作

C#中常见线程同步方法

我们介绍几种常用的C#进行线程同步的方式，这些方式可以根据其原理，找到对应上面的四种类型之一。

1、Interlocked

为多个线程共享的变量提供原子操作。

根据经验，那些需要在多线程情况下被保的资源通常是整型值，且这些整型值在多线程下最常见的操作就是递增、递减或相加操作。

Interlocked类提供了一个专门的机制用于完成这些特的操作。这个类提供了Increment、Decrement、Add静态方法用于对int或

long型变量的递增、递减或相加操作。此类的方法可以防止可能在列情况发生的错误：计划程序在某个线程正在更新可由其他线程访

问的变量时切换上下文；或者当两个线程在不同的处理器上并执行时。

此类的成员不引发异常。

Increment 和 Decrement 方递增或递减变量并将结果值存储在单个操作中。

在大多数计算机上，增变量操作不是一个原子操

作，需要执行下列步骤：

1)将实例变量中的值加载到寄存器中。

2)增加或减少该值。

3)在实例变量中存储该值。

如果不使用 Increment 和 Decrement，线程会在执行完前两个步骤后被抢先。

然后由另一个线程执行所有三个步骤。 当第一个线程

重新开始执行时，它覆盖实例变量中的值，造成第二个线程执行增减操作的结果丢失。

Exchange 方法自动交换指定变量的值。 CompareExchange

方法组合了两个操作：较两个值以及根据比较的结果将第三个值存储

在其中一个变量中。 比较和交换操作按原子操作执行。

案例分析：共享打印机。

通常我们会使用共享打印机，几台计算机共享一台打印机，每台计算机可以发出打印指令，可能会出现并发情况。当然我们知道，打印

机采用了队列技术。为了简化操作，我们假定，在打印机收到命令时，可打印，而且在同一时间只能有一个打印任务在执行。我们使

用Interlocked方法来实现多线程同步。具体代码如下：

using System; using System.Threading; namespace

MutiThreadSample.ThreadSynchronization { class

PrinterWithInterlockTest { /// \<summary\> /// 正在使用的打印机 ///

0代表未使用，1代表正在使用 ///

\</summary\> public static int UsingPrinter = 0; /// \<summry\> ///

计算机数量 /// \</summary\> publi

static readonly int ComputerCount = 3; /// \<summary\> /// 试 ///

\</summar\> public static void

TestPrnt() { Thread thread; Random random = new Random(); for (int i =

0; i \< ComputerCount; i++)

{ thread = new Thrad(MyThreadProc); thread.Name =

string.Format(\"Thread{0}\",i);

Thread.Sleep(randm.Next(3)); thread.Start(); } } /// \<summary\> ///

线程执行操作/// \</summary\>

private static void MyThreadPro() { //使用打印机进行打印 UsePrinter();

//当前线程等待1秒

Thread.Sleep(1000); } /// \<sumary\> /// 使用打印机进行打印 ///

\</summary\> private static bool

UsePrinter() {

//检查大引进是否在使用，如果原始值为0，则为未使用，可以进行打印，否则不能打印，继续等待

if (0 ==

Interlocked.Exchange(ref UsingPrinte, 1)) { Console.WriteLine(\"{0}

acquired the lock\",

Thread.CurrentThread.Name); //Code t access a resource that is not

thread safe would go here.

//Simulate some work Thread.Sleep(500); Console.WritLine(\"{0} exiting

lock\",

Thread.CurrentThread.Name); //释放打印机 Interlocked.Exchange(ref

UsingPrinter, 0); return true; }



else { Console.WriteLine(\" {0} was denied te lock\",

Thread.CurrentThread.Name); return false; } }

} }

2、lock 关键字

lock

关键字将语句块标记为临界区，方法是获取给定象的互斥锁，执行语句，然后释放该锁。

lock

确保当一个线程位于代码的临界区时，另一个线程不进入临界区。如果其他线程试图进入锁定的代码，则它将一直等待（即被阻

止），直该对象被释放。

public void Function() { System.Object loker= new System.Object();

lock(locker) { // Access

thread-sensitive resources. } }

lock 调用块开始位置的 Enter 和块结束位置的 Exit。

提供给 lock

关键字的参数必须为基于引用类型的对象，该对象用来定义锁的范围。在上例中，锁的范围限定为此函数，因为函数外不存

在任何对该对象的引用。严格地说，提供给 lock

的对象只是来唯一地标识由多个线程共享的资源，所以它可以是任意类实例。然而，

实际上，此对象通常表示需要进行线程步的资源。例如，如果一个容器对象将被多个线程使用，则可以将该容器传递给

lock，而 lock

后面的同步代码将访问该容器。只要其他线程在访问该容器前先锁定该容器，则对该对象的访问将是安全同步的。通常，最好避免锁

定 public

类型或锁定不受应用程序控制的对象实例，例如，如果该实可以被公开访问，则

lock(this) 可能会有问题，因为不受控制

的代码也可能会锁定该对象。这可能导致死锁，即两个或更多个线程等待释放同一对象出于同样的原因，锁定公共数据类型（相比于

对象）也可能导致问题。锁定字符串尤其危险，因为字符串被公共语言运行库

(CLR)"暂留"。这意味着整个程序中任何给定符串都只

有一个实例，就是这同一个对象表示了所有运行的应用程序域的所有线中的该文本。因此，只要在应用程序进程中的任何位置处具有

相同内容的字符串上放置了锁，就将锁定应用程序中该字符串的所有例。因此，最好锁定不会被暂留的私有或受保护成员。某些类提

供专门用于锁定的成员。例如，Array 类型提供SyncRoot。许多集合类型也提供

SyncRoot。

常见的结 lock (this)、lock (typeof (MyType)) 和 lock (\"myLock\")

违反此准则：

1）如果实例可以被公共访问，将出现 lock (thi) 问题。

2）如果 MyType 可以被公共访问，将出 lock (typeof (MyType)) 问题。

3）由于进程中使用同一字符串的任何其他代码将共享同一个锁，所以出

lock("myLock") 问题。

最佳做法是定义 private 对象来锁定, 或 privat static

对象变量来保护所有实例所共有的数据。关于锁的研究，大家可以参考：

http://www.cnblogs.com/yank/archive/2008/10/281321119.html

案例分析：继续使用共享打印机的案例

我们只需对前面的例稍作修改即可实现lock进行同步。

声明锁对象：

/// \<summary\> /// 正在使用的打印机 /// \</summary\> priate static

object UsingPrinterLocker = new

object();

将打印方法修改如下：

/// \<summary\> // 使用打印机进行打印 /// \</summary\> private static

void UsePrinter() { //临界区 lock

(UsingPrinterLocker) { Console.WriteLine(\"{0} acquired the lock\",

Thread.CurrentThread.Name); //模拟

打印操作 Thread.Sleep(500); Console.WriteLine(\"{0} exiting lock\",

Thread.CurrntThread.Name); } }

3、监视器

与 lock 关键字类似，监视器防止多个线程同时执行代码块。Enter

方法允许一且仅一个线程继续执行后面的语句；其他所有线程都将

被阻止，直到执行语句的线程调用 Exit。这与使用 lok

关键字一样。事实上，lock 关键字就是用 Monitor 类来现的。例如：（继续

修改共享打印机案例，增加方法UsePrinterWithMnitor）

/// \<ummary\> /// 使用打印机进行打印 /// \</summary\> private static

void UsePrinterWithMonitor() {

System.Threading.Monior.Enter(UsingPrinterLocker); try {

Console.WriteLine(\"{0} acquired the

lock\", Thread.CurrentThreadName); //模拟打印操作 Thread.Sleep(500);

Console.WriteLine(\"{0} exitng

lock\", Thrad.CurrentThread.Name); } finally {

System.Threading.Monitor.Exit(UsingPrinterLockr); }

}

使用 lock 关键字通常比直接使用 Monitor 类更可取，一方面因为 lock

更简洁，另一方面是因为 lock 确保了即使受保护的代码引

发异常，也可以释放基础监视器。这是通过 finally

关键字来实现的，无论是否发异常它都执行关联的代码块。



4、同步事件和等待句柄

使用锁或监视器对于防止同时执行区分线程的代码块很有用，但是这些构造不允许一线程向另一个线程传达事件。这需要"同步事

件"，它是有两个状态（终止和非终止）的对象，可以用来激活和起线程。让线程等待非终止的同步事件可以将线程挂起，将事件状态

更改为终止可以将线程激活。如果线程试图等待已终止的事件，则线程将继续执行，而不会延迟。

同步事件有两种：utoResetEvent 和

ManualResetEvent。它们之间唯一的不同在于，无论何时，只 AutoResetEvent

激活

线程，它的状态将自动从终止变为非终止。相反，ManualResetEvet

允许它的终止状态激活任意多个线程，只有当它的 Reset 方法

被调用时才还原到非终止状态。

等待句柄，可以通过调用一种等待方法，如 WaitOne、aitAny 或

WaitAll，让线程等待事件。

System.Threading.WaitHandle.WitOne

使线程一直等待，直到单个事件变为终止状态；

System.Threading.WaitHandle.WaitAny

阻止线程，直到一个或多个指示的事件变为终止状态；

System.hreading.WaitHandle.WaitAll

阻止线程，直到所有指示的事件都变为终止状态。当调用事件的 Set

方法时，事件将变为终

止状态。

AutoResetEvent 允许线程通过发信号互相通信。

通常，当线程需要独占访问资源时使用该类。线程通过调用 AutoResetEvent

上的 WaitOne 来等待信号。 如果 AutoResetEvent

为非终止状态，则线程会被阻止，并等待当前控制资源的线程通过调用 Set 来通

知资源可用。调用 Set 向 AutoResetEvent 发信号以释放等待线程。

AutoResetEvent 将保持终止状态，直到一个正在等待的线程被

释放，然后自动返回非终止状态。

如果没有任何线程在等待，则状态将无限期地保持为终止状态。如果当

AutoResetEvent 为终止状

态时线程调用 WaitOne，则线程不会被阻止。 AutoResetEvent

将立即释放线程并返回到非终止状态。

可以通过将一个布尔值传递给构造函数来控制 AutoResetEvent

的初始状态：如果初始状态为终止状态，则为 true；否则为 false。

AutoResetEvent 也可以同 staticWaitAll 和 WaitAny 方法一起使用。

案例：

案例介绍：

今天我们来做饭，做饭呢，需要一菜、一粥。今天我们吃鱼。

熬粥和做鱼，是比较复杂的工作流程，

做粥：选材、淘米、熬制

做鱼：洗鱼、切鱼、腌制、烹调

为了提高效率，我们用两个线程来准备这顿饭，但是，现在只有一口锅，只能等一个做完之后，另一个才能进行最后的烹调。

来看实例代码：

using System; using System.Threading; namespace

MutiThreadSample.ThreadSynchronization { ///

\<summary> /// 案例：做饭 /// 今天的Dinner准备吃鱼，还要熬粥 ///

熬粥和做鱼，是比较复杂的工作流程， /// 做粥：选

材、淘米、熬制 /// 做鱼：鱼、切鱼、腌制、烹调 ///

我们用两个线程来准备这顿饭 /// 但是，现在只有一口锅，只能等个

做完之后，另一个才能进行最后的烹调 /// \</summary\ class CookResetEvent

{ /// \<summary\> ////// \</summary\>

private AutoResetEvent resetvent = new AutoResetEvent(false); ///

\<summary\> /// 做饭 /// \</summary\

public void Cook() { Thrad porridgeThread = new Thread(new

ThreadStar(Porridge));

porridgeThread.Name = \"Porridge\"; porridgeThread.Start(); Thread

makeFishThread = new Thread(new

ThreadStart(MakeFish)); makeFishThread.Name = \"MakeFish\";

makeFishThread.Start(); //等待5秒

Thread.Sleep(5000); resetEvent.Reset(); } /// \<summary\> /// 熬粥 ///

\</summary\> public void

Porridge() { //选材 Console.WriteLine(\"Thread:{0},开始选材\",

Thread.CurrentThread.Name); //淘米

Console.WriteLine(\"Thread:{0},开始淘米\", Thread.CurrentThread.Name);

//熬制

Console.WriteLine(\"Thread:{0},开始熬制，需要2秒钟\",

Thread.CurrentThread.Name); //需要2秒钟

Thread.Sleep(2000); Console.WriteLine(\"Thread:{0},粥已经做好，锅闲了\",

Thread.CurrentThread.Name);

resetEvent.Set(); } /// \<summry\> /// 做鱼 /// \</summary\> public

void MakeFish() {//洗鱼

Console.WriteLin(\"Thread:{0},开始洗鱼\",Thread.CurrentThread.Name);

//腌制 Console.WriteLine(\Thread:

{0},开始腌制\", Thread.CurrentThread.Name); //等待锅闲出来

resetEvent.WaitOne(); //烹调

Console.WriteLine(\"Thread:{0},终于有锅了\", Thread.CurrentThread.Name);

Console.WriteLine(\"Thread:{0},

开始做鱼,需要5秒钟\", Thread.CurrentThread.Name); Thread.Sleep(5000);

Console.WriteLine(\"Thread:{0},鱼做

好了，好香\", Thread.CurrentThread.Name); resetEvent.Set(); } } }

ManualResetEvent与AutoResetEvent用法基本类似，这里不多做介绍。

5、Mutex对象

mutex

与监视器类似；它防止多个线程在某一时间同时执行某个代码。事实上，名称"mutex"是术语"互相排斥

(mutually

exclusive)"的简写形式。然而与监视器不同的是，mutex

可以用来使跨进程的线程同步。mutex 由 Mutex 类表示。当用于进程间同

步时，mutex 称为"命名

mutex"，因为它将用于另一个应用程序，因此它能通过全局变量或静态变量共享。必须给它指定一个名

称，才能使两个应用程序访问同一个 mutex 对象。

尽管 mutex 可以用于进程内的线程同步，但是使用 Monitor

通常更为可取，因为监视器是专门为 .NET Framework 而设计的，

因而它可以更好地利用资源。相比之下，Mutex 类是 Win32 构造的包装。尽管

mutex 比监视器更为强大，但是相对于 Monitor 类，



它所需要的互操作转换更消耗计算资源。

本地 mutex 和系统 mutex

Mutx 分两种类型：本地 mutex 和命名系统 mutex。

如果使用接受名称的构造函数创建了 Mutex 对象，那么该对象将与具有

该名称的操作系统对象相关联。 命名的系统 mutex

在整个操作系统中都可见，并且可用于同步进程活动。 您可以创建多个 Mutex

对

象来表示同一命名系统 mutex，而且您可以使用 OpenExisting

方法打开现有的命名系统 mutex。

本地 mutex 仅存在于进程当中。 进程中引用本地 Mutex

对象的任意线程都可以使用本地 mutex。 每个 Mutex 对象都是一个单

独的本地 mutex。

在本地Mutex中，用法与Monitor基本一致

继续修改前面的打印机案例：

声明Mutex对象：

/// \<summary\> /// mutex对象 /// \</summary\> private static Mutex

mutex = new Mutex();

具体操作：

/// \<summary\> /// 使用打印机进行打印 /// \</summary\> private static

void UsePrinterWithMutex() {

mutex.WaitOne(); try { Console.WriteLine(\"{0} acquired the lock\",

Thread.CurrentThread.Name); //模拟

打印操作 Thread.Sleep(500); Console.WriteLine(\"{0} exiting lock\",

Thread.CurrentThread.Name); }

finally { mutex.ReleaseMutex(); } }

多线程调用：

/// \<summary\> /// 测试 /// \</summary\> public static void TestPrint()

{ Thread thread; Random random

= new Random(); for (int i = 0; i \< ComputerCount; i++) { thread = new

Thread(MyThreadProc);

thread.Name = string.Format(\"Thread{0}\", i);

Thread.Sleep(random.Next(3)); thread.Start(); } } ///

\<summary\> /// 线程执行操作 /// \</summary\> private static void

MyThreadProc() { //使用打印机进行打印

//UsePrinter(); //monitor同步 //UsePrinterWithMonitor(); //用Mutex同步

UsePrinterWithMutex(); //当前线

程等待1秒 Thread.Sleep(1000); }

最后的打印机案例代码：

using System; using System.Threading; namespace

MutiThreadSample.ThreadSynchronization { class

PrinterWithLockTest { /// \<summary\> /// 正在使用的打印机 ///

\</summary\> private static object

UsingPrinterLocker = new object(); /// \<summary\> /// 计算机数量 ///

\</summary\> public static readonly

int ComputerCount = 3; /// \<summary\> /// mutex对象 /// \</summary\>

private static Mutex mutex = new

Mutex(); /// \<summary\> /// 测试 /// \</summary\> public static void

TestPrint() { Thread thread;

Random random = new Random(); for (int i = 0; i \< ComputerCount; i++) {

thread = new

Thread(MyThreadProc); thread.Name = string.Format(\"Thread{0}\", i);

Thread.Sleep(random.Next(3));

thread.Start(); } } /// \<summary\> /// 线程执行操作 /// \</summary\>

private static void MyThreadProc()

{ //使用打印机进行打印 //UsePrinter(); //monitor同步

//UsePrinterWithMonitor(); //用Mutex同步

UsePrinterWithMutex(); //当前线程等待1秒 Thread.Sleep(1000); } ///

\<summary\> /// 使用打印机进行打印 ///

\</summary\> private static void UsePrinter() { //临界区 lock

(UsingPrinterLocker) {

Console.WriteLine(\"{0} acquired the lock\", Thread.CurrentThread.Name);

//模拟打印操作

Thread.Sleep(500); Console.WriteLine(\"{0} exiting lock\",

Thread.CurrentThread.Name); } } ///

\<summary\> /// 使用打印机进行打印 /// \</summary\> private static void

UsePrinterWithMonitor() {

System.Threading.Monitor.Enter(UsingPrinterLocker); try {

Console.WriteLine(\"{0} acquired the

lock\", Thread.CurrentThread.Name); //模拟打印操作 Thread.Sleep(500);

Console.WriteLine(\"{0} exiting

lock\", Thread.CurrentThread.Name); } finally {

System.Threading.Monitor.Exit(UsingPrinterLocker); }

} /// \<summary\> /// 使用打印机进行打印 /// \</summary\> private static

void UsePrinterWithMutex() {

mutex.WaitOne(); try { Console.WriteLine(\"{0} acquired the lock\",

Thread.CurrentThread.Name); //模拟

打印操作 Thread.Sleep(500); Console.WriteLine(\"{0} exiting lock\",

Thread.CurrentThread.Name); }

finally { mutex.ReleaseMutex(); } } } }



6、读取器/编写器锁

ReaderWriterLockSlim

类允许多个线程同时读取一个资源，但在向该资源写入时要求线程等待以获得独占锁。

可以在应用程序中使用

ReaderWriterLockSlim，以便在访问一个共享资源的线程之间提供协调同步。

获得的锁是针对

ReaderWriterLockSlim 本身的。

设计您应用程序的结构，让读取和写入操作的时间尽可能最短。

因为写入锁是排他的，所以长时间的写入操作会直接影响吞吐量。

长时间的读取操作会阻止处于等待状态的编写器，并且，如果至少有一个线程在等待写入访问，则请求读取访问的线程也将被阻止。

案例：构造一个线程安全的缓存

using System; using System.Threading; using System.Collections.Generic;

namespace

MutiThreadSample.ThreadSynchronization { /// \<summary\> /// 同步Cache

/// \</summary\> public class

SynchronizedCache { private ReaderWriterLockSlim cacheLock = new

ReaderWriterLockSlim(); private

Dictionary\<int, string\> innerCache = new Dictionary\<int, string\>();

/// \<summary\> /// 读取 ///

\</summary\> /// \<param name=\"key\"\>\</param\> ///

\<returns\>\</returns\> public string Read(int key) {

cacheLock.EnterReadLock(); try { return innerCache\[key\]; } finally {

cacheLock.ExitReadLock(); } }

/// \<summary\> /// 添加项 /// \</summary\> /// \<param

name=\"key\"\>\</param\> /// \<param name=\"value\"\>

\</param\> public void Add(int key, string value) {

cacheLock.EnterWriteLock(); try {

innerCache.Add(key, value); } finally { cacheLock.ExitWriteLock(); } }

/// \<summary\> /// 添加项，有超

时限制 /// \</summary\> /// \<param name=\"key\"\>\</param\> /// \<param

name=\"value\"\>\</param\> /// \<param

name=\"timeout\"\>\</param\> /// \<returns\>\</returns\> public bool

AddWithTimeout(int key, string value,

int timeout) { if (cacheLock.TryEnterWriteLock(timeout)) { try {

innerCache.Add(key, value); }

finally { cacheLock.ExitWriteLock(); } return true; } else { return

false; } } /// \<summary\> /// 添

加或者更新 /// \</summary\> /// \<param name=\"key\"\>\</param\> ///

\<param name=\"value\"\>\</param\> ///

\<returns\>\</returns\> public AddOrUpdateStatus AddOrUpdate(int key,

string value) {

cacheLock.EnterUpgradeableReadLock(); try { string result = null; if

(innerCache.TryGetValue(key,

out result)) { if (result == value) { return

AddOrUpdateStatus.Unchanged; } else {

cacheLock.EnterWriteLock(); try { innerCache\[key\] = value; } finally {

cacheLock.ExitWriteLock(); }

return AddOrUpdateStatus.Updated; } } else { cacheLock.EnterWriteLock();

try { innerCache.Add(key,

value); } finally { cacheLock.ExitWriteLock(); } return

AddOrUpdateStatus.Added; } } finally {

cacheLock.ExitUpgradeableReadLock(); } } /// \<summary\> /// 删除项 ///

\</summary\> /// \<param

name=\"key\"\>\</param\> public void Delete(int key) {

cacheLock.EnterWriteLock(); try {

innerCache.Remove(key); } finally { cacheLock.ExitWriteLock(); } } ///

\<summary\> /// /// \</summary\>

public enum AddOrUpdateStatus { Added, Updated, Unchanged }; } }

7、Semaphore 和 SemaphoreSlim

System.Threading.Semaphore

类表示一个命名（系统范围）信号量或本地信号量。 它是一个对 Win32

信号量对象的精简包

装。 Win32 信号量是计数信号量，可用于控制对资源池的访问。

SemaphoreSlim

类表示一个轻量的快速信号量，可用于在一个预计等待时间会非常短的进程内进行等待。

SemaphoreSlim 会

尽可能多地依赖由公共语言运行时 (CLR) 提供的同步基元。

但是，它也会根据需要提供延迟初始化的、基于内核的等待句柄，以支持

等待多个信号量。 SemaphoreSlim

还支持使用取消标记，但它不支持命名信号量或使用等待句柄来进行同步。

线程通过调用 WaitOne 方法来进入信号量，此方法是从 WaitHandle 类派生的。

当调用返回时，信号量的计数将减少。 当一个

线程请求项而计数为零时，该线程会被阻止。 当线程通过调用 Release

方法释放信号量时，将允许被阻止的线程进入。 并不保证被阻

塞的线程进入信号量的顺序，例如先进先出 (FIFO) 或后进先出

(LIFO)。信号量的计数在每次线程进入信号量时减小，在线程释放信号

量时增加。 当计数为零时，后面的请求将被阻塞，直到有其他线程释放信号量。

当所有的线程都已释放信号量时，计数达到创建信号量

时所指定的最大值。

案例分析：购买火车票

还得排队进行购买，购买窗口是有限的，只有窗口空闲时才能购买

using System; using System.Threading; namespace

MutiThreadSample.ThreadSynchronization { ///

\<summary\> /// 案例：支付流程 ///

如超市、药店、火车票等，都有限定的几个窗口进行结算，只有有窗口空闲，才能进行结算。

/// 我们就用多线程来模拟结算过程 /// \</summary\> class

PaymentWithSemaphore { /// \<summary\> /// 声明收银员

总数为3个，但是当前空闲的个数为0，可能还没开始上班。 /// \</summary\>

private static Semaphore IdleCashiers =

new Semaphore(0, 3); /// \<summary\> /// 测试支付过程 /// \</summary\>

public static void TestPay() {

ParameterizedThreadStart start = new ParameterizedThreadStart(Pay);

//假设同时有5个人来买票 for (int i

= 0; i \< 5; i++) { Thread thread = new Thread(start); thread.Start(i);

} //主线程等待，让所有的的线程都



激活 Thread.Sleep(1000);

//释放信号量，2个收银员开始上班了或者有两个空闲出来了

IdleCashiers.Release(2); }

/// \<summary\> /// /// \</summary\> /// \<param

name=\"obj\"\>\</param\> public static void Pay(object obj)

{ Console.WriteLine(\"Thread {0} begins and waits for the semaphore.\",

obj); IdleCashiers.WaitOne();

Console.WriteLine(\"Thread {0} starts to Pay.\",obj); //结算

Thread.Sleep(2000);

Console.WriteLine(\"Thread {0}: The payment has been finished.\",obj);

Console.WriteLine(\"Thread {0}:

Release the semaphore.\", obj); IdleCashiers.Release(); } } }

8、障碍（Barrier）4.0后技术

使多个任务能够采用并行方式依据某种算法在多个阶段中协同工作。

通过在一系列阶段间移动来协作完成一组任务，此时该组中的每个任务发信号指出它已经到达指定阶段的

Barrier 并且暗中等待其他任

务到达。 相同的 Barrier 可用于多个阶段。

9、SpinLock(4.0后)

SpinLock结构是一个低级别的互斥同步基元，它在等待获取锁时进行旋转。

在多核计算机上，当等待时间预计较短且极少出现争用

情况时，SpinLock 的性能将高于其他类型的锁。

不过，我们建议您仅在通过分析确定 System.Threading.Monitor 方法或

Interlocked 方法显著降低了程序的性能时使用 SpinLock。

即使 SpinLock 未获取锁，它也会产生线程的时间片。

它这样做是为了避免线程优先级别反转，并使垃圾回收器能够继续执行。

在使用 SpinLock

时，请确保任何线程持有锁的时间不会超过一个非常短的时间段，并确保任何线程在持有锁时不会阻塞。

由于 SpinLock

是一个值类型，因此，如果您希望两个副本都引用同一个锁，则必须通过引用显式传递该锁。

using System; using System.Text; using System.Threading; using

System.Threading.Tasks; namespace

MutiThreadSample.ThreadSynchronization { class SpinLockSample { public

static void Test() {

SpinLock sLock = new SpinLock(); StringBuilder sb = new StringBuilder();

Action action = () =\> {

bool gotLock = false; for (int i = 0; i \< 100; i++) { gotLock = false;

try { sLock.Enter(ref

gotLock); sb.Append(i.ToString()); } finally { //真正获取之后，才释放 if

(gotLock) sLock.Exit(); } } };

//多线程调用action Parallel.Invoke(action, action, action);

Console.WriteLine(\"输出：

{0}\",sb.ToString()); } } }

10、SpinWait(4.0后)

System.Threading.SpinWait

是一个轻量同步类型，可以在低级别方案中使用它来避免内核事件所需的高开销的上下文切换和内

核转换。

在多核计算机上，当预计资源不会保留很长一段时间时，如果让等待线程以用户模式旋转数十或数百个周期，然后重新尝试获

取资源，则效率会更高。

如果在旋转后资源变为可用的，则可以节省数千个周期。

如果资源仍然不可用，则只花费了少量周期，并且仍

然可以进行基于内核的等待。

这一旋转-等待的组合有时称为"两阶段等待操作"。

下面的基本示例采用微软案例：无锁堆栈

using System; using System.Threading; namespace

MutiThreadSample.ThreadSynchronization { public

class LockFreeStack\<T\> { private volatile Node m_head; private class

Node { public Node Next;

public T Value; } public void Push(T item) { var spin = new SpinWait();

Node node = new Node {

Value = item }, head; while (true) { head = m_head; node.Next = head;

if

(Interlocked.CompareExchange(ref m_head, node, head) == head) break;

spin.SpinOnce(); } } public

bool TryPop(out T result) { result = default(T); var spin = new

SpinWait(); Node head; while (true)

{ head = m_head; if (head == null) return false; if

(Interlocked.CompareExchange(ref m_head,

head.Next, head) == head) { result = head.Value; return true; }

spin.SpinOnce(); } } } }

总结：

尽管有这么多的技术，但是不同的技术对应不同的场景，我们必须熟悉其特点和适用范围。在应用时，必须具体问题具体分析，选择最

佳的同步方式。

