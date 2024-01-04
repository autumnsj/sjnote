# java

## 一. jrebel 热部署

插件名: j rebel

- 下载反代理工具 https://github.com/ilanyu/ReverseProxy/releases/tag/v1.4

- 到https://guidgen.com/ 生成guid 

  如: 3b049c75-85e7-4f96-a6a4-f49bdb8fef7a

- 将生成的guid 拼接到 http:/127.0.0.1:8888/ 后面

  如: http:/127.0.0.1:8888/3b049c75-85e7-4f96-a6a4-f49bdb8fef7

- 粘贴到注册界面并随便填写邮箱

![image-20231207101722336](.assets/java/image-20231207101722336.png)

## 二. SpringBoot 在IDEA中实现热部署

### 学习目标

快速学会在项目中使用热部署插件运行项目，提高开发效率。

### 快速查阅

### 具体步骤

### 1、开启IDEA的自动编译（静态）

具体步骤：打开顶部工具栏 File -> Settings -> Default Settings -> Build -> Compiler 然后勾选 Build project automatically 。

![img](.assets/java/webp-1702345040214-7.webp)

### 2、开启IDEA的自动编译（动态）

具体步骤：同时按住 Ctrl + Shift + Alt + / 然后进入Registry ，勾选自动编译并调整延时参数。

- compiler.automake.allow.when.app.running -> 自动编译
- compile.document.save.trigger.delay -> 自动更新文件

PS：网上极少有人提到compile.document.save.trigger.delay 它主要是针对静态文件如JS CSS的更新，将延迟时间减少后，直接按F5刷新页面就能看到效果！

![img](.assets/java/webp-1702345040214-8.webp)

### 3、开启IDEA的热部署策略（非常重要）

具体步骤：顶部菜单- >Edit Configurations->SpringBoot插件->目标项目->勾选热更新。

![img](.assets/java/webp-1702345040214-9.webp)

image.png

### 4、在项目添加热部署插件（可选）

> 温馨提示：
> 如果因为旧项目十分臃肿，导致每次都自动热重启很慢而影响开发效率，笔者建议直接在POM移除`spring-boot-devtools`依赖，然后使用Control+Shift+F9进行手工免启动快速更新！！

具体步骤：在POM文件添加热部署插件



```xml
       <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
        </dependency>
```

### 5、关闭浏览器缓存（重要）

打开谷歌浏览器，打开F12的Network选项栏，然后勾选【✅】Disable cache 。

![img](.assets/java/webp-1702345040214-10.webp)

热部署到底有多爽呢，用渣渣辉的话来说，只需体验三分钟，你就会干我一样，爱上这款呦西。

## 三 Stream 流常用操作

```java
//查找某值最大的项写法1
PrcWayBillPriceVo priceVo = zoneList.stream().filter(x -> x.getStartValue().compareTo(bill.getWeightCharge()) >= 0).max((x, y) -> x.getStartValue().compareTo(y.getStartValue())).orElse(null);
//查找某值最大的项写法2
PrcWayBillPriceVo priceVo = zoneList.stream().filter(x -> x.getStartValue().compareTo(bill.getWeightCharge()) >= 0).max(Comparator.comparing(PrcWayBillPriceVo::getStartValue)).orElse(null);
```



