#define \_WIN32_WINNT 0x0501 //仅XP或以上系统有效

#include \windows.h\>

int main)

{

RECT rc;

HND hwnd = FindWindow(TEXT(\"Notepad\"), NULL); //注意窗口不能最小化

if (wnd == NULL)

{

cout \<\< \"找不到记事本窗口" \<\< endl;

retun 0;

}

GetClientRect(hwnd, &rc);

/创建

HDC hdcScreen = GetD(NULL);

HDC hdc = CreateCompatibleDC(hdcSceen);

HBITAP hbmp = CreateCompatibleBitmap(hdcScreen, rc.right - rc.left,

rc.bottom - rc.top)

SelectObject(hdc, hbmp);

//复制

PrintWindow(hwnd, hdc, PW_CLIENTONLY);

//PW_CLIENTONLY：Only the client area of the window is copied to

hdcBlt.

//By default, the entire window is copied.

//PW_CLIENTONLY表示仅仅拷贝窗口的客户区域，而默认情况下，执行printwindow会拷贝整个窗

口

//复制到粘贴板

OpenClipboard(NULL);

EmptyClipboard();

SetClipboardData(CF_BITMAP, hbmp);

CloseClipboard();

//释放

DeleteDC(hdc);

DeleteObject(hbmp);

ReleaseDC(NULL, hdcScreen);



cout \<\< \"成功把记事本窗口复制到粘贴板,请粘贴到Windows画图工具\" \<\<

endl;

return 0;

}

