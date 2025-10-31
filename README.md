# MAAresUpdater
<s>一键给牛牛换裤衩</s>一键更新Maa资源文件

byd懒得手动更，于是摸了一个脚本。

2025.10.31更新：
从 `batch` 脚本切换使用 `python` 脚本实现，多平台兼容，为什么不呢？

考虑到这个脚本已经稳定实现功能了，所以大概率不会再更新了。
<s>谁家换裤衩还整流水线</s>

本项目采用 `AGPL-3.0` 协议开源，详情请参阅 `LICENSE` 文件。

> 由于本项目使用 `nuitka` 编译为可执行文件，而某些病毒软件打包方式酷似/使用 `nuitka` ，因此可能会出现杀毒软件误报，请放心换裤衩。 

---
## 使用方法

1.下载编译后的可执行文件：[releases](https://github.com/NaivG/MAAresUpdater/releases)(稳定版)  / [GitHub Actions](https://github.com/NaivG/MAAresUpdater/actions)(最新版)

**注意：为了区分平台，你下载到的可执行文件是 `updater_windows.exe` 这样带系统后缀的，并不影响使用**

2.将编译后的程序并放置在MAA根目录，打开updater_.exe或者执行`.\updater`以自动更新。

### 其根目录看起来应该是这样的：

    maa
     ├─adb
     ├─cache
     ├─config
     ├─debug
     ├─Python
     ├─resource
     ├─MAA.exe
     ├─...
    *└─updater.exe

## 手动编译

**本项目选择nuitka编译，若需复现则编译前请先安装Visual C++ Build Tools**

1.克隆项目

```bash
git clone https://github.com/NaivG/MAAresUpdater.git
```

2.安装python3.9+环境，并安装依赖包

```bash
pip install -r requirements.txt
```

3.使用python库编译可执行文件

```bash
pip install nuitka
nuitka --standalone --output-dir=dist --onefile updater.py
```

## bug反馈

如果遇到任何问题，欢迎提交issue。

## 鸣谢

- 感谢以下git镜像源(排序不分先后)：
  - [bgithub.xyz](https://bgithub.xyz)
  - [ghproxy.net](https://ghproxy.net)
  - [ghfast.top](https://ghfast.top)
  - [ghp.ci](https://ghp.ci)
  - [kgithub.com](https://kkgithub.com)
  - [gitproxy.click](https://gitproxy.click)
  - [moeyy.xyz](https://github.moeyy.xyz)
  - [gitclone.com](https://gitclone.com)
  - [tbedu](https://github.tbedu.top)
  - [gh.llkk.cc](https://gh.llkk.cc)
  - [gh-deno.mocn.top](https://gh-deno.mocn.top)