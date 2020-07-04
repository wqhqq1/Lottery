import xlrd as excel_reader
import xlwt as excel_writer
from os import remove as delete
from random import sample as rand
from tkinter import *
from tkinter import filedialog
from tkinter import messagebox
from pyperclip import copy as ClipBoardWrite

chosefilename = ''
out = ''
showchooser = False

def textrander(ExcelPath, rands, FirstPriceNumber, SecondPriceNumber, ThirdPriceNumber, OtherPriceNumber):
    n = 0
    FirstPrice = '一等奖：'
    names = excel_reader.open_workbook(r'%s' % ExcelPath)
    names = names.sheet_by_name('Sheet1')
    priceopener = excel_writer.Workbook(encoding='gbk')
    pricewriter = priceopener.add_sheet('Sheet1', cell_overwrite_ok=True)
    excel_border =excel_writer.Borders()
    excel_border.left = 0x01
    excel_border.right = 0x01
    excel_border.top = 0x01
    excel_border.bottom = 0x01
    excel_alignment = excel_writer.Alignment()
    excel_alignment.horz = 0x02
    excel_alignment.vert = 0x01
    title_border = excel_writer.Borders()
    title_border.left = 0x01
    title_border.top = 0x01
    title_border.bottom = 0x01

    style = excel_writer.XFStyle()
    style.borders = excel_border
    style.alignment = excel_alignment
    style_title = excel_writer.XFStyle()
    style_title.borders = title_border
    pricewriter.write(0, 0, ExcelPath + '的抽奖结果', style_title)
    pricewriter.write(1, 0, '一等奖', style)
    while n < FirstPriceNumber:
        if FirstPriceNumber - n == 1:
            FirstPrice += names.cell(rands[n], 0).value
        else:
            FirstPrice += names.cell(rands[n],0).value + '、'
        pricewriter.write(1, FirstPriceNumber - n, names.cell(rands[n], 0).value, style)
        n+=1
        # print(n)
    e = n+SecondPriceNumber
    SecondPrice = '二等奖：'
    pricewriter.write(2, 0, '二等奖', style)
    while n < e:
        if e - n == 1:
            SecondPrice += names.cell(rands[n],0).value
        else:
            SecondPrice += names.cell(rands[n], 0).value + '、'
        pricewriter.write(2, e - n, names.cell(rands[n], 0).value, style)
        n+=1
        # print(n)
    e = n+ThirdPriceNumber
    pricewriter.write(3, 0, '三等奖', style)
    ThirdPrice = '三等奖：'
    while n < e:
        if e - n == 1:
            ThirdPrice += names.cell(rands[n],0).value
        else:
            ThirdPrice += names.cell(rands[n], 0).value + '、'
        pricewriter.write(3, e - n, names.cell(rands[n], 0).value, style)
        n+=1
        # print(n)
    e = n+OtherPriceNumber
    pricewriter.write(4, 0, '鼓励奖', style)
    OtherPrice = '鼓励奖：'
    while n < e:
        if e - n == 1:
            OtherPrice += names.cell(rands[n],0).value
        else:
            OtherPrice += names.cell(rands[n], 0).value + '、'
        pricewriter.write(4, e - n, names.cell(rands[n], 0).value, style)
        n+=1
        # print(n)
    try:
        delete(ExcelPath + '抽奖结果' + ' .xls')
    except:
        pass
    priceopener.save(ExcelPath + '抽奖结果' + ' .xls')
    global out
    out = ExcelPath + '的抽奖结果是:' + '\n' + FirstPrice + '\n' + SecondPrice + '\n' + ThirdPrice + '\n' + OtherPrice
    ClipBoardWrite(out)

def rand_chooser(ExcelPath, AllNumber, FirstPriceNumber, SecondPriceNumber, ThirdPriceNumber, OtherPriceNumber):
    n = 0
    rands_temp = [i for i in range(1,AllNumber+1)]
    rands = rand(rands_temp, FirstPriceNumber+SecondPriceNumber+ThirdPriceNumber+OtherPriceNumber)
    # print(rands_temp)
    textrander(ExcelPath, rands, FirstPriceNumber, SecondPriceNumber, ThirdPriceNumber, OtherPriceNumber)

def inputer(Excel_Path, AllNumber, FirstPriceNumber, SecondPriceNumber, ThirdPriceNumber, OtherPriceNumber):
    Excel_Path = Excel_Path
    AllNumber = int(AllNumber)
    FirstPriceNumber = int(FirstPriceNumber)
    SecondPriceNumber = int(SecondPriceNumber)
    ThirdPriceNumber = int(ThirdPriceNumber)
    OtherPriceNumber = int(OtherPriceNumber)
    try:
        rand_chooser(Excel_Path, AllNumber, FirstPriceNumber, SecondPriceNumber, ThirdPriceNumber, OtherPriceNumber)
    except:
        global showchooser
        showchooser = False
        messagebox.showerror('错误', '获奖人数大于总人数！请检查输入的数据。')

def getallnumber(Excel_Path):
    names = excel_reader.open_workbook(r'%s' % Excel_Path)
    names = names.sheet_by_name('Sheet1')
    n = 0
    while True:
        try:
            names.cell(n+1, 0).value
            n += 1
        except:
            return n

    # print(n)

def graphics():
    def filechoose():
        global chosefilename
        chosefilename = filedialog.askopenfilename(filetypes = [('Excel表格文件', '*.xlsx *.xls')])
        ExcelPathEntry.config(state = 'normal')
        ExcelPathEntry.delete(0, END)
        ExcelPathEntry.insert(0, chosefilename)
        ExcelPathEntry.config(state = 'disabled')
        AllNumberEntry.config(state = 'normal')
        AllNumberEntry.delete(0, END)
        AllNumberEntry.insert(0, getallnumber(chosefilename))
        AllNumberEntry.config(state = 'disabled')
    def start():
        global out
        global showchooser
        if showchooser:
            if messagebox.askokcancel('警告', '你已经抽过一次奖，再次抽奖会覆盖上一次的结果，你确定要再抽一次吗？'):
                showchooser = False
                start()
            else:
                return
        else:
            showchooser = True
            inputer(ExcelPathEntry.get(), AllNumberEntry.get(), FirstPriceNumberEntry.get(),SecondPriceNumberEntry.get(), ThirdPriceNumberEntry.get(), OtherPriceNumberEntry.get())
            ShowPriceText.config(state = 'normal')
            ShowPriceText.delete(0.0, END)
            ShowPriceText.insert(END, out)
            ShowPriceText.config(state = 'disabled')

    root = Tk()
    root.geometry('600x500')
    root.title('抽奖器')
    ExcelPathLabel = Label(text = '选择Excel表格文件', font = ('', 15))
    ExcelPathLabel.grid(row = 0, column = 0)
    ExcelPathEntry = Entry(font = ('', 20), state = 'disabled')
    ExcelPathEntry.grid(row = 0, column = 1)
    ExcelPathButton = Button(text = '选择文件', font = ('', 15), command = filechoose)
    ExcelPathButton.grid(row = 0, column = 2)
    AllNumberLabel = Label(text = '参与抽奖的总人数：', font = ('', 15))
    AllNumberLabel.grid(row = 1, column = 0)
    AllNumberEntry = Entry(font = ('', 20), state = 'disabled')
    AllNumberEntry.grid(row = 1, column = 1)
    FirstPriceNumberLabel = Label(text = '一等奖获奖人数：', font = ('', 15))
    FirstPriceNumberLabel.grid(row = 2, column = 0)
    FirstPriceNumberEntry = Entry(font = ('', 20))
    FirstPriceNumberEntry.grid(row = 2, column = 1)
    SecondPriceNumberLabel = Label(text = '二等奖获奖人数：', font = ('', 15))
    SecondPriceNumberLabel.grid(row = 3, column = 0)
    SecondPriceNumberEntry = Entry(font = ('', 20))
    SecondPriceNumberEntry.grid(row = 3, column = 1)
    ThirdPriceNumberLabel = Label(text = '三等奖获奖人数：', font = ('', 15))
    ThirdPriceNumberLabel.grid(row = 4, column = 0)
    ThirdPriceNumberEntry = Entry(font = ('', 20))
    ThirdPriceNumberEntry.grid(row = 4, column = 1)
    OtherPriceNumberLabel = Label(text = '鼓励奖获奖人数：', font = ('', 15))
    OtherPriceNumberLabel.grid(row = 5, column = 0)
    OtherPriceNumberEntry = Entry(font = ('', 20))
    OtherPriceNumberEntry.grid(row = 5, column = 1)
    ShowPriceText = Text(font = ('', 15), width = 28, height = 13, state = 'disabled')
    ShowPriceText.grid(row = 6,column = 1)
    StartButton = Button(text = '开始抽奖', font = ('', 15),command = start)
    StartButton.grid(row = 7, column = 1, padx=5, pady=5)
    root.mainloop()
if __name__ == '__main__':
    graphics()