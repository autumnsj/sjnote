## ubuntu部署DNS

> ##### 条件: 开放53端口, 并同时允许TCP和UDP协议通过

### 1.安装bind9

```bash
apt install bind9
```

``` bash
vim /etc/bind/named.conf.options
```

**给 /etc/bind/named.conf.options 添加内容**

``` conf
 //上游DNS
 forwarders {
     233.5.5.5;
 };
 //允许所有访问,默认只允许本机
 allow-query {any;}; 
```

**将rndc.key 添加 named.conf配置末尾**

> **如果后续需要程序修改dns记录,需要用到rndc.key** 以下是rndc.key文件内容示例
>
> key "rndc-key" {
>         algorithm hmac-sha256;
>         secret "jrI3ltMs5jW0+tlXhwlHjpaI9Bq73NDtKHiMR+3A3NA=";
> };

``` bash
vim /etc/bind/named.conf
```

``` conf
// This is the primary configuration file for the BIND DNS server named.
//
// Please read /usr/share/doc/bind9/README.Debian.gz for information on the
// structure of BIND configuration files in Debian, *BEFORE* you customize
// this configuration file.
//
// If you are just adding zones, please do that in /etc/bind/named.conf.local

include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
include "/etc/bind/named.conf.default-zones";
//添加的项
include "/etc/bind/rndc.key";

```





### 2.添加要解析的域名

``` bash
vim /etc/bind/named.conf.local
```

```conf
zone "carriercentral.vip" {
        type master;
        file "/var/lib/bind/carriercentral.vip";
        //允许指定key修改域名配置
        allow-update { key rndc-key; }; 
};

```

### 3.以`/etc/bind/db.local`为模板创建域名文件

  ``` bash 
  cp  /etc/bind/db.local    /var/lib/bind/carriercentral.vip
  ```

并修改为

> 需要注意的是, 这里的NS记录不能修改为carriercentral.vip, 千万不要修改为carriercentral.vip,否则解析会出问题,这个是指定由谁来解析这个域名,如果不设为本机,那所有记录不生效

``` 
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     carriercentral.vip. root.carriercentral.vip. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      localhost.
@       IN      A       112.74.170.125
@       IN      AAAA    ::1

```

### 4.重启bind9生效

```bash
systemctl restart bind9
```

测试是否生效

```bash
nslookup carriercentral.vip 112.74.170.125
```

输出以下信息代表部署成功:

`root@gangwan:~# nslookup carriercentral.vip 112.74.170.125`
`Server:         112.74.170.125`
`Address:        112.74.170.125#53`

`Name:   carriercentral.vip`
`Address: 112.74.170.125`
`Name:   carriercentral.vip`
`Address: ::1`
