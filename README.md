Lottery  
=============
Description
----------------
#### This program can auto get name excel table file and do lottery  
#### You can customise the name of the prizes and the number of each prizes  
#### This program can not run well in Linux now, so don't try that without any changes  
#### The platform now supported is Windows, macOS and iOS(iPadOS), you should download binary file on Windows or run [the code below](#Download) on macOS
#### You also can [click the code](#Download) below to insall on iOS(iPadOS)
Download
---------------------------------  
#### For windows, you can download binary file here:[![](https://img.shields.io/github/v/release/wqhqq1/Lottery?color=green)](https://github.com/wqhqq1/Lottery/releases/tag/3.0)
#### For macOS, you can run the code below:  
#### make sure you have already installed python 3
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/wqhqq1/Lottery/master/load_macos)"
```  
#### For iOS(iPadOS) click the button to install
#### [![](https://img.shields.io/badge/Install%20on%20iOS-v3.0-Green)]()
Build
----------  
#### If you want to build the code by yourself, you should do the three steps below:  
### 1. build environment
   - Python 3.7 or higher
### 2. depended python wheels
   - pyperclip
   - xlrd
   - xlwt
   - pyinstaller
### 3. run the codes below in terminal
```
git clone https://github.com/wqhqq1/Lottery.git
cd ./Lottery
pyinstaller -F Main.py
```
