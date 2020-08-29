Lottery  
=============
Description
----------------
#### This program can auto get name from excel table file and do lottery  
#### You can customise the name of the prizes and the number of each prizes  
#### This program can not run well in Linux now, so don't try that without any changes  
#### The platform now supported is macOS and iOS(iPadOS), you should download binary file macOS or install for iDevices by AltStore with the ipad file.
#### Update for Windows was stopped yet but the binary file was broken(maybe fix later), too.
Download
---------------------------------  
#### For iOS(iPadOS) you can download the iPA file here:[![](https://img.shields.io/github/v/release/wqhqq1/Lottery?color=green)](https://github.com/wqhqq1/Lottery/releases/tag/5.0)
#### For macOS, you can get the app file here:[![](https://img.shields.io/github/v/release/wqhqq1/Lottery?color=green)](https://github.com/wqhqq1/Lottery/releases/tag/5.0)
#### For windows, you can download binary file here:[![](https://img.shields.io/github/v/release/wqhqq1/Lottery?color=green)](https://github.com/wqhqq1/Lottery/releases/tag/3.0)
Build From Source Code
----------  
#### If you want to build the code by yourself, you should do these steps below:  
### macOS
#### 1. build environment
   - Xcode 12.0 or higher for macOS(also can build for iOS)
#### 2. Just click build in Xcode for iOS
#
### Windows
#### 1. build environment
   - Python 3.7 or higher for Windows
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
