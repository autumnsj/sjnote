C++中COM调用方法

发表于2008/4/2 11:01:00 8866人阅读

\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

Requirement:

1创建myCom.dll,该COM只有一个组件,两个接口IGetRes\--方法Hello(),

IGetResEx\--方法HelloEx(

2.在工程中导入组件或类型库

#import \"组件在目录myCom.dll\" no_namespace

或

#import \"类型库所在目录mCom.tlb\"

using namespace MCOM;

\--Method

1\-\-\-\-\-\\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

CoInitialize(NLL);

CLSID clsid;

CLSIDFromProgID(OESTR(\"myCom.GetRes\"),&clsid);

CComPtr\<IGetRes\> pGetRes;//智能指针

pGetRes.CoCeateInstance(clsid);

pGetRes-\>Hello();

pGetRes.Release();/小心哦!!请看最后的"注意"

CoUninitialize();

\--Method

2\-\-\-\-\-\-\-\-\-\-\--\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

CoInitialize(NULL);

CLSID clsid;

HRESULT hr=CLSDFromProgID(OLESTR(\"myCom.GetRes\"),&clsid);

IGetRes \*ptr;

hr=CoCreateInstance(clsid,NULL,CLSCTX_INPROC_SERVER,

\_\_uuidof(IGetRes),(LPVOID\*)&ptr);

ptr-\>Hello();

CoUninitialize();

\--Method

3\-\-\-\-\-\-\-\-\-\-\-\-\--\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

CoInitialize(NULL);

HRESULT hr;

CLSID clsid;

hr=CLSIDFromProgIDOLESTR(\"myCom.GetRes\"),&clsid);

IetRes\* ptr;

IetResEx\* ptrEx;

//使用CoCreateClassObject创建一个组件(特别是mutilThreads)的多个对象的



时候，效率更高.

IClassFactory\* p_classfactory;

hr=CoGetClassObject(clsid,CLSCTX_INPRO_SERVER,

NULL,IID_IClassFactry,

(LPVOID\*)&p_classfctory);

p_classfactory-\>CreateInstance(NULL,\_\_uuidof(IGtRes),

(LPVOID\*)&ptr);

pclassfactory-\>CreateInstance(NULL,\_\_uuidof(IGetResEx),

(LPVOID\*)&ptrEx);

ptr-\>Hello();

ptrEx-\>HelloEx();

CoUninitialize();

\--Method

4\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

直接从dll中得到DllGetClasObject，接着生成类对象及类实例（这方法可以

使组件不用在注册表里注册,这是最原的方法,但这样做没什么意义,至少失去了COM

对用户的透明性）,不推荐使用.

typedef HRESULT (\_\_stdcall \* pfnHello)(REFCLSID,REFIID,void\*\*);

pfnHello fnHello= NULL;

HINSTANCE hdllInst = LoadLibrary(\"组件所在目录myCom.dll\");

fnHello=(pfnHello)GetProcAddress(hdllInst,\"DllGetClassObject\");

if (fnHello != 0)

{

IClassFactory\* pcf = NULL;

HRESULT hr=(fnHello)(CLSID_GetRes,IID_IClassFactory,(void\*\*)&pcf);

if (SUCCEEDED(hr) && (pcf != NULL))

{

IGetRes\* pGetRes = NULL;

hr = pcf-\>CreateInstance(NULL, IID_IFoo, (void\*\*)&pGetRes);

if (SUCCEEDED(hr) && (pFoo != NULL))

{

pGetRes-\>Hello();

pGetRes-\>Release();

}

pcf-\>Release();

}

}

FreeLibrary(hdllInst);



\--Method

5\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

通过ClassWizard利用类型库生成包装类，不过前提是com组件的接口必须是派

生自IDispatch,具体方法：

调出添加类向导(.NET中)，选择类型库中MFC类，打开，选择\"文件\"，选择

\"myCom.dll\"或\"myCom.tlb\",接下来会出来该myCom中的所有接口，选择你想

生成的接口包装类后，向导会自动生成相应的.h文件.这样你就可以在你的MFC中

像使用普通类那样使用组件了.（CreateDispatch(\"myCom.GetRes\")

中的参数就是ProgID通过Clsid

在注册表中可以查询的到）

CoInitialize(NULL);

CGetRes getRest;

if (getRest.CreateDispatch(\"myCom.GetRes\") != 0)

{

getRest.Hello();

getRest.ReleaseDispatch();

}

CoUninitialize();

\--注意\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

COM中的智能指针实际上是重载了-\>的类,目的是为了简化引用记数,几不需要程序

员显示的调用AddRef()和Release(),但是为什么我们在Method 1中

pGetRes.Release(),问题在与,我们的智能指针pGetRes生命周期的结束是在

CoUninitialize()之后,CoInitialize所开的套间在CoUninitialize()后已经被

关闭,而pGetRes此时发生析构,导致了程序的崩溃,解决这个问题的另一个方法是

CoInitialize(NULL);

CLSID clsid;

CLSIDFromProgID(OLESTR(\"myCom.GetRes\"),&clsid);

{

CComPtr\<IGetRes\> pGetRes;//智能指针

pGetRes.CoCreateInstance(clsid);

pGetRes-\>Hello();

}

CoUninitialize();

\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

以上就是COM的5中方法,当然具体怎么使用还是在于程序的环境,加以琢磨\....

