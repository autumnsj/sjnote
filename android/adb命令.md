2.使用指令打开设置页面

```powershell
adb shell am start com.android.settings/com.android.settings.Settings
#取到当前所运行的activity, 第一行是当前界面
adb shell dumpsys activity recents | findstr "intent={"
```

