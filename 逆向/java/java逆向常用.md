<center><h1>java逆向常用</h1></center>

https://codeleading.com/article/44771264375/

## 一. 简单类

例子

```java
public class test {
	public static int a;
	private static int b;
	public test() {
		a = 0;
		b = 0;
	}
	public static void set_a(int input) {
		a = input;
	}
	public static int get_a() {
		return a;
	}

	public static void set_b(int input) {
		b = input;
	}
	public static int get_b() {
		return b;
	}
}
```

编译

```
javac test.java
```



反编译

```
javap -c -verbose test.class
```

构造方法，把所有的静态成员变量设置成0

```delphi
  public test();
    descriptor: ()V
    flags: ACC_PUBLIC
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: iconst_0
         5: putstatic     #2                  // Field a:I
         8: iconst_0
         9: putstatic     #3                  // Field b:I
        12: return
```

a的setter方法

```cpp
  public static void set_a(int);
    descriptor: (I)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=1, locals=1, args_size=1
         0: iload_0
         1: putstatic     #2                  // Field a:I
         4: return
```

a的getter方法

```cpp
  public static int get_a();
    descriptor: ()I
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=1, locals=0, args_size=0
         0: getstatic     #2                  // Field a:I
         3: ireturn
```

b的setter方法

```cpp
 public static void set_b(int);
    descriptor: (I)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=1, locals=1, args_size=1
         0: iload_0
         1: putstatic     #3                  // Field b:I
         4: return
```

b的getter方法

```cpp
  public static int get_b();
    descriptor: ()I
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=1, locals=0, args_size=0
         0: getstatic     #3                  // Field b:I
         3: ireturn
```

无论这个类的成员变量是公有还是私有，代码执行起来没有区别，但是成员变量的类型信息会显示再class文件中，在其他任何文件中都不能直接访问到类的私有成员变量。



接下来我们创建一个对象去调用其中的方法

//ex1.java

```java
public class ex1 {
	public static void main(String[] args) {
		test obj = new test();
		obj.set_a(1234);
		System.out.println(obj.a);
	}
}
```

反编译

```delphi
  public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=2, locals=2, args_size=1
         0: new           #2                  // class test
         3: dup
         4: invokespecial #3                  // Method test."<init>":()V
         7: astore_1
         8: aload_1
         9: pop
        10: sipush        1234
        13: invokestatic  #4                  // Method test.set_a:(I)V
        16: getstatic     #5                  // Field java/lang/System.out:Ljava/io/PrintStream;
        19: aload_1
        20: pop
        21: getstatic     #6                  // Field test.a:I
        24: invokevirtual #7                  // Method java/io/PrintStream.println:(I)V
        27: return
```

new指令创建了一个对象，但是没有调用其中的构造方法(构造方法在偏移块4中调用了)

偏移块14调用了set_a()方法

偏移块21访问了test类中的成员变量a

## 二.Java逆向基础之导出内存中的类

我们有时候可能会遇到暂时无法使用javaagent的情况，如服务器上的Web应用重启太耗时，这是我们可以考虑用下面的方法。

使用dumpclass，目前dumpclass在Windows上表现不佳，建议在Linux上使用

dumpclass项目地址

https://github.com/hengyunabc/dumpclass

下载地址

http://central.maven.org/maven2/io/github/hengyunabc/dumpclass/0.0.2/dumpclass-0.0.2.jar



使用dumpclass之前需要配置path

编辑~/.bashrc

```
sudo gedit ~/.bashrc
```

在

```
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
```

后加

```
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib:${JAVA_HOME}/lib/tools.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/sa-jdi.jar
```

使环境变量生效

```
source ~/.bashrc
```



使用方法

先用jps查看运行的java进程

```ruby
root@machine:~$ jps
4965 Jps
2361 org.eclipse.equinox.launcher_1.3.0.v20140415-2008.jar
2605 AppServer
```

我们需要dump的进程为AppServer，进程id记下来

之后dumpAppServer进程中以Employee结尾的类

```
java -jar dumpclass-0.0.2.jar 2605 *Employee out --classLoaderPrefix
```

2605为dump的进程，*Employee表示以Employee结尾的类，out为导出的目录



第一次dump可能会遇到的问题，提示"Can't attach to the process"

```
cd /etc/sysctl.d
```

该目录下有一个名为“10-ptrace.conf”的文件，

```
sudo nano 10-ptrace.conf
```

以超级用户权限打开该文件，并将里面的一行kernel.yama.ptrace_scope = 1修改为kernel.yama.ptrace_scope = 0

保存并退出，重启系统。

（如果你纳闷为什么要这么改的话，可以好好看下那个文件里面的注释）

