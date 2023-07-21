C#操作IE浏览器

最近的一个B/S系统中，用到了指模录入，当用户按了手指摸之后，要在IE浏览器的一个文本框上显示用户的姓名。由于

要监控指模机的输入，因此客户端需要装一个.net控制台程序，通过此控制台程序监控指模机。这个没办法。这个.net控制台

程序装在公司前台的电脑上就OK了。然后通过局域网与指模机相联，当用户按手指摸并且验证通过之后，从指模机读取用户

的姓名，然后检测当前浏览器是否有打开系统上的某个页面。如果有，则将姓名输入到IE浏览器的响应文本框。

这里用到的最麻烦的一个东东就是C#操作IE浏览器。之前太孤陋寡闻，一开始的想法是控制台程序发送上远程服务器，

然后页面AJAX轮询，但是耗用比较大的资源。下面主要通过com组件实现控制台程序操作IE。

1、首先，需要添加com组件的引用

加入对Microsoft Internet Controls的引用；

加入对Microsoft HTML Object Library的引用；(其实就是的mshtml)

2、打开一个新Tab并打开指定地址

//新建一个Tab，然后打开指定地址 SHDocVw.ShellWindows shellWindows = new

SHDocVw.ShellWindowsClass();

object objFlags = 1; object objTargetFrameName = \"\"; object

objPostData = \"\"; object objHeaders =

\"\"; SHDocVw.InternetExplorer webBrowser1=

(SHDocVw.InternetExplorer)shellWindows.Item(shellWindows.Count-1);

webBrowser1.Navigate(\"http://www.baidu.com\", ref objFlags, ref

objTargetFrameName, ref objPostData,

ref objHeaders);

如果需要手动启动IE浏览器进程的话，可以使用：

Process.Start(\"iexplore.exe\"); //直接打开IE浏览器(打开默认首页)

Process.Start(\"iexplore.exe\",\"http://www.cnblogs.com/kissdodog\");

//直接打开IE浏览器，打开指定页

3、操作js

下面，通过操作js实现如下效果：往百度搜索框里面输入\"刘德华\"并点击搜索。

//遍历所有选项卡 foreach (SHDocVw.InternetExplorer Browser in

shellWindows) { if

(Browser.LocationURL.Contains(\"www.baidu.com\")) { //通过操作js点击按钮

if (Browser.Document is

HTMLDocumentClass) { HTMLDocumentClass doc2 = Browser.Document as

HTMLDocumentClass;

HTMLScriptElement script =

(HTMLScriptElement)doc2.createElement(\"script\"); //script.text =

\"alert(123);\"; //恰好百度用了jQuery script.text =

\"\$(\\\"#kw1\\\").val(\'刘德华\'); \$(\\\"#su1\\\").click();\";

HTMLBodyClass body = doc2.body as HTMLBodyClass;

body.appendChild((IHTMLDOMNode)script); } } }

4、C#直接通过DOM操作IE

C#直接通过Dom操作IE

SHDocVw.ShellWindows shellWindows = new SHDocVw.ShellWindowsClass();

//遍历所有选项卡 foreach

(SHDocVw.InternetExplorer Browser in shellWindows) { if

(Browser.LocationURL.Contains(\"www.baidu.com\")) {

mshtml.IHTMLDocument2 doc2 =

(mshtml.IHTMLDocument2)Browser.Document; mshtml.IHTMLElementCollection

inputs =

(mshtml.IHTMLElementCollection)doc2.all.tags(\"INPUT\");

mshtml.HTMLInputElement input1 =

(mshtml.HTMLInputElement)inputs.item(\"kw1\", 0); input1.value =

\"刘德华\"; mshtml.IHTMLElement

element2 = (mshtml.IHTMLElement)inputs.item(\"su1\", 0);

element2.click(); } }

5、在里面操作IFrame

操作IFrame是一个比较麻烦的操作，很多方式都不能实现，目前唯一的办法是通过在页面上执行一段js实现操作IFrame

（希望有人能告诉我）。

2014年8月5日 热死人了

特别说明：上个星期去客户电脑上部署的时候，mshtml.dll无论如何都调用不成功，但是在客户机子上装了VS之后，又

不用改代码又成功了。首先提示找不到mshtml.dll

7.0.33。然后网上找到一堆方法，把复制都本地设置为True了。然后又这

又那都不行。尝试了如下方法之后好像OK了，特别做记录。

mshtml.dll 文件没有被 IE

正确关联，可运行命令使其再次关联。关联方法较简单，点击"开始"菜单里的"运行"，在空

框处填入 regsvr32 /u mshtml.dll 命令先卸载关联，如果卸载成功，会提示"

mshtml.dll 中的 DllUnregisterServer 成

功。"，然后再填入 regsvr32 mshtml.dll

命令进行关联，如果关联成功，会提示" mshtml.dll 中的 DllRegisterServer

成

功。"，最后重启电脑即可。此法最好在安全模式下进行，以防系统正在使用

mshtml.dll 文件而导致卸载和关联失败。此法

我也试过，对我无效，希望对其它网友有用。

如果提示找不到dll文件，那么将C:\\Program Files\\Microsoft.NET\\Primary

Interop

Assemblies\\Microsoft.mshtml.dll复制到C:\\Windows\\assembly

System.NotImplementedException: 未实现该方法或操作。

可以尝试在

C:\\WINDOWS\\Microsoft.NET\\Framework\\v2.0.50727目录下运行RegAsm.exe

C:\\Program Files\\Microsoft.NET\\Primary Interop

Assemblies\\Microsoft.mshtml.dll

mshtml.dll /registered

最后把代码改为：

string sName = \"IE测试\"; ShellWindows shellWindows = new

ShellWindowsClass(); foreach

(InternetExplorer Browser in shellWindows) { if (Browser.Document is

HTMLDocument) { HTMLDocument

doc2 = Browser.Document as HTMLDocument; HTMLScriptElement script =

(HTMLScriptElement)doc2.createElement(\"script\"); if

(sName.Contains(\"\\0\")) { sName =

sName.Substring(0, sName.IndexOf(\"\\0\")); } script.text =

string.Format(\"alert(\\\"弹出此对话框则正

常!\\\")\", sName); HTMLBody body = doc2.body as HTMLBody; if (body ==

null) { MessageBox.Show(\"果然是

Body为NULL\"); } else { body.appendChild((IHTMLDOMNode)script); } } }

注意，区别在于把类变了 : HTMLDocumentClass =\>

HTMLDocument,HTMLBodyClass =\> HTMLBody。

这样就在客户机子上不用装VS都可以了，至于为什么这么改就可以，暂时不得而知，最近实在忙。没时间深究。

解决：COM 组件的调用返回了错误 HRESULT E_FAIL

这个东西总在Browser.Document时发生，经过查看，发现Document的状态始终都为未加载完毕时(实际上已加载完

毕，客户机子IE8 XP)就会出现此错误。

不要用这个属性了，通过LocalhostUrl属性判断是否这个页面(就是说尽量避开这个Document，有无解Bug)。

