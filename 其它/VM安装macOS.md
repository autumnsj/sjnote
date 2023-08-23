## 安裝步驟：

1、首先下載並安裝 VMWare 虛擬機軟體**【[官網下載](https://www.vmware.com/cn/products/workstation-pro/workstation-pro-evaluation.html)】**

2. 下載**【[VMWare Unlocker】](https://github.com/paolo-projects/unlocker)**，**以管理員身份運行 win-install**

3.下載 macOS 14 索諾瑪 （Sonoma）的 ISO 系統文件【**[點擊下載](https://www.mediafire.com/file/lzlounvkwazy948/macOS+Sonoma+ISO.iso/file)**】

4.創建虛擬機，轉到**我的文檔 -> 虛擬機 -> macOS 14 虛擬機文件，**

然後在 **右鍵單擊** 2 KB 的**macOS 14 (.VMX) 文件，然後選擇****使用記事本打開，並在底部輸入以下內容：**

```none
smc.version = "0"
```

全选代码

复制

5.正式開始安裝

6.

```
啟用乙太網：

搜索 ethernet0.virtualDev = "e1000e" 並將 e1000e替換 為 vmxnet3 並保存文件。
```

