C_C++变量命名规则

变量命名规则是为了增强代码的可读性和容易维护性。以下为C++必须遵守的变量命名规：

1、 变量名只能是字母（A-Z，a-z）和数字（-9）或者下划线（\_）组成。

2、 第一个字必须是字母或者下划线开头。

3、 不能使用C++键字来命名变量，以免冲突。

4、 变量名区分大小写。

变量命名规则：

一、 用最短字符示最准确的意义。

二、 使用变量前缀。

1、 整型前缀

int nId; //int前缀：n

short sId; //short前缀：s

unsigned int unId // unsgned int 前缀：un

long lId //long前缀：l

2、 浮点型前

float Value; //float前缀：f

double dValue; //double前缀：d

3、 字符型前缀

char chChar; //char前缀：h

4、 字符串前缀

char szPth; //char字符串前缀：sz

string strPath; //strng字符串前缀：str

CString strPath; //MFC CString类前：str

5、 布尔型前缀

bool bIsOK; //bool类型前缀：b

BOOL bIsOK; //MFC OOL前缀：b

6、 指针型前缀

char \* pPath; /指针前缀：p

7、 数组前缀

int arrnNum; //数组

前缀：arr

CString arrstrName; //数组前缀+类型前缀+名

8、 结构体前缀



STUDENT tXiaoZhang; //结构体前缀：t

9、 枚举前缀

eum emWeek; //枚举前缀：em

10、 字节的前缀

BYTE byIP; //字节前

缀：by

11、 字的前缀

DWORD dwMsgID; //双前缀：dw

WORD wMsgID; //单字前缀：w

12、 字符指针前缀

LPCTSTR ptszName; //CHAR类型为ptsz

LPCSTR pszName; //pcz

LPSTR pszName; //psz

13、 STL容器前缀

vector vecValue; //vetor容器前缀：vec

14、 RECT矩形结构前缀

RECT rcChild; //rc

CRECT rcChild/ //rc

15、 句柄前缀

HWND hWndDlg; //h

HBRUSH hBr; //h

HPEN hPen; //h

HBITMAP hBmpBack; //h

16、 Windows颜色前缀

COLORREF crFont; //cr

17、 Windows DC前缀

CDC dcClient; //dc

三、 类的成员变量以m_开头，后面为变量，变量同时还要加前缀。

CString m_strName; //m_开头+类型前缀+名称

四、 定义一个变量，为了简化，在不影响变量意义的情况下，可仅仅使用前缀。

RECT rc;



五、 全局变量一律以g_开头，后面为变量，变量同时还要加前缀。

int g_ID; //g

六、

定义结构体，保证C和C++兼容，采用typedef语句，并且结构体类型全部大写，以T\_

开头，指针形式以PT_开头。

typedef struct tag TSTUDENT

{

int nId;

CString strName;

}STUDENT,\*PSTUDENT;

STUDENT tXiaoZhang; //完整定义结构体

七、 变量由多个单词组成，则每个单词的首个字母大写。

int nStudentID;

CString strStudentName;

八、 定义一个类以C或者T做为类名前缀。

class CMyListCtrl;

class TMyListCtrl;

九、 MFC控件绑定值类别或者控件类类别，需要以m_开头并且加前缀。

CEdit m_EDT_strValue;

//Edit绑定控件类别

CListBox m_LB_nName;

//ListBox

CListCtrl m_LC_Name;

//ListCtrl;

CComboBox m_CB_Name;

/ComboBox

十、 控件ID尽量简化并表明控件类型和意义。

Button IDC_BTN_NAME;

Edit IDC_EDT_NAME;

ListBox IDC_LB_NAME;

ListCtrl IDC_LC_NAME;

ComboBox IDC_CB_NAME;

