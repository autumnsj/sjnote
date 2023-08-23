## appium

- 安装appium-desktop https://github.com/appium/appium-desktop

- 设置环境变量 ANDRIOD_HOME 等于android sdk目录

- 初始化一个Python项目 并安装依赖库

  ``` shell
  pip install appium-python-client
  ```

- 使用adb命令获取要调试的应用包名和actitity

``` powershell
#取到当前所运行的activity, 第一行是当前界面
adb shell dumpsys activity recents | findstr "intent={"
```



- 编写代码

  ```python
  import time
  import unittest
  from appium import webdriver
  from appium.webdriver.common.appiumby import AppiumBy
  
  capabilities = {
      'platformName': 'Android',
      'platformVersion': '11',  # 填写android虚拟机/真机的系统版本号
      'deviceName': 'MuMu',  # 填写安卓虚拟机/真机的设备名称 (安卓可以随便写)
      'appPackage': 'com.ss.android.ugc.aweme',  # 填写被测app包名
      'appActivity': '.splash.SplashActivity',  # 填写被测app的入口
      'noReset': True,  # 是否重置APP
      'unicodeKeyboard': False,  # 是否支持中文输入
      'resetKeyboard': True,  # 是否支持重置键盘
      'newCommandTimeout': 6000  # 30秒没发送新命令就断开连接
  }
  
  # 连接appium server，初始化自动化环境
  # q 应用闪退了，怎么办？ a 重启appium server
  # q重启了appium server，还是不行，怎么办？ a重启电脑
  
  driver = webdriver.Remote('http://localhost:4723/wd/hub', capabilities)  #闪退
  
  # 1.获取屏幕尺寸
  size = driver.get_window_size()
  print(size)
  # 2.获取屏幕宽度
  width = size['width']
  print(width)
  # 3.获取屏幕高度
  height = size['height']
  print(height)
  # 4.获取屏幕中心点坐标
  center_x = width / 2
  center_y = height / 2
  print(center_x, center_y)
  # 重复点击屏幕中心点
  for i in range(1000):
      driver.tap([(center_x, center_y)])
      time.sleep(0.05)
  print('点击完成')
  ```

  
