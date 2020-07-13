Lottery  
=============
Discription
----------------
#### This program can auto get name from xlsx or xls file and do lottery  
#### You can customise the name of the prizes and the number of each prizes  
#### This program can not run well in Linux now, so don't try that without any changes  
#### The platform now supported is Windows and macOS, you should download binary file on Windows or run the code below on macOS  
#### 3.0 version is almost done now! It has more universal than before
#### You downlodad beta version here:[![](https://img.shields.io/github/v/release/wqhqq1/Lottery?color=orange&include_prereleases)](https://github.com/wqhqq1/Lottery/releases/tag/3.0-beta4)  
Download
-------------  
#### For windows, you can download binary file here:[![](https://img.shields.io/github/v/release/wqhqq1/Lottery?color=orange)](https://github.com/wqhqq1/Lottery/releases/tag/2.6)
#### For macOS, you can run the code below:  
#### make sure you have already installed python 3
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/wqhqq1/Lottery/master/load_macos)"
```  
Build
----------  
#### If you want to build the code by yourself, you should install the dependencies in the list:  
1. build environment
   - Python 3.7 or higher
2. python wheels
   - pyperclip
   - xlrd
   - xlwt
   - pyinstaller
3. run this codes in terminal
```
git clone https://github.com/wqhqq1/Lottery.git
cd ./Lottery
pyinstaller -F Main.py
```
