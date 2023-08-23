

# ubuntu ssh

## 启用**root**帐户

```bash
#先设置root密码
sudo passwd root

```

1. Start by

   opening a command line terminal

   and opening the

   ```
   /etc/ssh/sshd_config
   ```

   SSH configuration file with nano or your preferred text editor. Be sure to do this with

   root permissions

   ```
   vim /etc/ssh/sshd_config
   ```

2. Inside this file, we need to uncomment the

   ```
   #PermitRootLogin prohibit-password
   ```

   . See below to see how your line should look.

   ```bash
   FROM:
   #PermitRootLogin prohibit-password
   TO:
   PermitRootLogin yes
   ```

   The quick way to do this job could be just to simply use the `sed` command as shown below:

   ```bash
   $ sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
   ```

3. Now we must restart the SSH service in order for the changes to take effect.

   ```bash
   $ sudo systemctl restart ssh
   ```

## ssh超时

**ssh远程登录服务器，如果一段时间没有操作就会被迫下线。这在一定程度上提高了远程运维的安全性。但是如果时间设置的太短，往往会造成不便。**
为了解决这个问题需要进行以下设置：
方法一：通过服务端配置解决

1. 设置ssh的定期重试

``` bash
vim /etc/ssh/sshd_config 
```

#server每隔60秒发送一次请求给client，然后client响应，从而保持连接
**ClientAliveInterval 60**
#server发出请求后，客户端没有响应得次数达到3，就自动断开连接，正常情况下，client不会不响应
**ClientAliveCountMax 3**
如果回话超时时，有类似如下的提示

2.修改shell的过期时间

**timed out waiting for input: auto-logout**
一般是因为linux设置了shell长时间没有输入时自动断开连接。
这个需要修改/etc/profile文件。

``` bash
vim /etc/profile
```

3. 查看文件里是否有如下内容，如果有则把数值改为0，或者用#号注释掉此行（此数值为超时的秒数，此时100为100秒，改为0则不超时。也可以改为更大的值）

**export TMOUT=100**
保存文件，运行以下命令重新加载配置文件

``` bash
 source /etc/profile
```

3.  最后重启 ssh

```bash
 systemctl restart ssh
```

方法二：通过客户端设置解决
根据使用客户端的不同，有不同的设置方法，暂不在这里详细说明了。

## 密钥登录

### 1. 本地制作密钥对 (必须是cmd,powershell不行)

```bash
C:\Users\Administrator>ssh-keygen -t rsa    #输入命令
Generating public/private rsa key pair.
Enter file in which to save the key (C:\Users\Administrator/.ssh/id_rsa): #这里直接回车默认
Enter passphrase (empty for no passphrase):	#密钥锁码在使用私钥时必须输入，这样就可以保护私钥不被盗用。当然，也可以留空，实现无密码登录。
Enter same passphrase again:
Your identification has been saved in C:\Users\Administrator/.ssh/id_rsa.
Your public key has been saved in C:\Users\Administrator/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:36f3Pg4jLpH1UZwg3oGMT1R9Y+YXCr00ltduac2aTkc administrator@Autumn
The key's randomart image is:
+---[RSA 3072]----+
|          +o++= o|
|         ..=o*.@o|
|          o.+.Xo*|
|           o + +E|
|        S o . o=.|
|         + . .+ .|
|          o..=.. |
|         .. .o=. |
|          .....++|
+----[SHA256]-----+

C:\Users\Administrator>
```

### 2. 在服务器上安装公钥

使用命令复制公钥到服务器上,

``` cmd 
#先进入.ssh目录, 不进去复制不了, 很奇怪
cd ~/.ssh
#复制公钥文件到服务器
scp -r -o PreferredAuthentications=password id_rsa.pub root@<服务器IP>:~/.ssh/id_rsa.pub
```

键入以下命令，在服务器上安装公钥：

```
[root@host ~]$ cd .ssh
[root@host .ssh]$ cat id_rsa.pub >> authorized_keys
```

如此便完成了公钥的安装。为了确保连接成功，请保证以下文件权限正确：

```
[root@host .ssh]$ chmod 600 authorized_keys
[root@host .ssh]$ chmod 700 ~/.ssh
```

### 3. 设置 SSH，打开密钥登录功能

编辑 /etc/ssh/sshd_config 文件，进行如下设置：

```
RSAAuthentication yes
PubkeyAuthentication yes
```

另外，请留意 root 用户能否通过 SSH 登录：

```
PermitRootLogin yes
```

当你完成全部设置，并以密钥方式登录成功后，再禁用密码登录：

```
PasswordAuthentication no
```

最后，重启 SSH 服务：

```
[root@host .ssh]$ service sshd restart
```

### 4. 将私钥下载到客户端，然后转换为 PuTTY 能使用的格式

然后打开 PuTTYGen，单击 Actions 中的 Load 按钮，载入你的私钥文件。如果你刚才设置了密钥锁码，这时则需要输入。

载入成功后，PuTTYGen 会显示密钥相关的信息。在 Key comment 中键入对密钥的说明信息，然后单击 Save private key 按钮即可将私钥文件存放为 PuTTY 能使用的格式。

今后，当你使用 PuTTY 登录时，可以在左侧的 Connection -> SSH -> Auth 中的 Private key file for authentication: 处选择你的私钥文件，然后即可登录了，过程中只需输入密钥锁码即可。

## 5. VSCode 使用密钥远程登录

``` config
Host <服务器IP>
  HostName <服务器IP>
  User root
  PasswordAuthentication no
  IdentityFile ~/.ssh/id_rsa
```
