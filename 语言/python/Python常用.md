## python常用

## 

## 创建虚拟环境
### 在Python中,可以使用以下方法创建虚拟环境:1. 使用venv模块(Python 3.3+版本内置)

```
python -m venv myenv
```
### 这会在当前目录下创建一个名为myenv的虚拟环境。2. 使用virtualenv工具

```
pip install virtualenv
virtualenv myenv
```
### 首先需要用pip安装virtualenv,然后创建虚拟环境。3. 使用conda创建环境

```
conda create -n myenv python=3.6
```
### pipenv的常用使用方式如下:
1. 安装pipenv

```
pip install pipenv
```

2. 创建虚拟环境并安装包

```
pipenv install requests
```

这将自动创建虚拟环境并安装requests包。3. 进入虚拟环境

```
pipenv shell
```

4. 安装/卸载包

```
pipenv install/uninstall <package>
```

5. 显示依赖信息

```
pipenv graph
```

6. 锁定依赖版本

```
pipenv lock
```

7. 退出虚拟环境

```
exit
```

8. 删除虚拟环境

```
pipenv --rm
```

主要是通过pipenv install安装第一个包时自动创建环境,然后使用pipenv shell进入环境,pipenv install/uninstall来安装卸载包,pipenv lock锁定依赖版本。pipenv可以大大简化virtualenv的虚拟环境管理流程。 （已编辑） 
