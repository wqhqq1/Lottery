import xlrd as excel_reader
import xlwt as excel_writer
from os import remove as delete
from random import sample as rand
from tkinter import *
from tkinter import filedialog
from tkinter import messagebox
from tkinter.scrolledtext import ScrolledText
from pyperclip import copy as ClipBoardWrite

chosefilename = ''
out = ''
showchooser = False

def textrander():
    global rands, Excel_Path, FirstPriceNumber, SecondPriceNumber, ThirdPriceNumber, OtherPriceNumber, AllNumber, FirstPriceName, SecondPriceName, ThirdPriceName, OtherPriceName
    n = 0
    FirstPrice = FirstPriceName
    names = excel_reader.open_workbook(r'%s' % Excel_Path)
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
    ExcelName = Excel_Path.strip('.xlsx')
    ExcelName = ExcelName.strip('.xls')
    ExcelTitle = re.sub(r'.*/', '', ExcelName)
    pricewriter.write(0, 0, ExcelTitle + '的抽奖结果', style_title)
    pricewriter.write(1, 0, FirstPrice, style)
    while n < FirstPriceNumber:
        if FirstPriceNumber - n == 1:
            FirstPrice += names.cell(rands[n], 0).value
        else:
            FirstPrice += names.cell(rands[n],0).value + '、'
        pricewriter.write(1, FirstPriceNumber - n, names.cell(rands[n], 0).value, style)
        n+=1
        # print(n)
    e = n+SecondPriceNumber
    SecondPrice = SecondPriceName
    pricewriter.write(2, 0, SecondPrice, style)
    while n < e:
        if e - n == 1:
            SecondPrice += names.cell(rands[n],0).value
        else:
            SecondPrice += names.cell(rands[n], 0).value + '、'
        pricewriter.write(2, e - n, names.cell(rands[n], 0).value, style)
        n+=1
        # print(n)
    e = n+ThirdPriceNumber
    ThirdPrice = ThirdPriceName
    pricewriter.write(3, 0, ThirdPrice, style)
    while n < e:
        if e - n == 1:
            ThirdPrice += names.cell(rands[n],0).value
        else:
            ThirdPrice += names.cell(rands[n], 0).value + '、'
        pricewriter.write(3, e - n, names.cell(rands[n], 0).value, style)
        n+=1
        # print(n)
    e = n+OtherPriceNumber
    OtherPrice = OtherPriceName
    pricewriter.write(4, 0, OtherPrice, style)
    while n < e:
        if e - n == 1:
            OtherPrice += names.cell(rands[n],0).value
        else:
            OtherPrice += names.cell(rands[n], 0).value + '、'
        pricewriter.write(4, e - n, names.cell(rands[n], 0).value, style)
        n+=1
        # print(n)
    try:
        delete(ExcelName + '抽奖结果' + ' .xls')
    except:
        pass
    priceopener.save(ExcelName + '抽奖结果' + ' .xls')
    global out
    out = ExcelTitle + '的抽奖结果是:' + '\n' + FirstPrice + '\n' + SecondPrice + '\n' + ThirdPrice + '\n' + OtherPrice
    ClipBoardWrite(out)

def rand_chooser():
    global rands, Excel_Path, FirstPriceNumber, SecondPriceNumber, ThirdPriceNumber, OtherPriceNumber, AllNumber, FirstPriceName, SecondPriceName, ThirdPriceName, OtherPriceName
    n = 0
    rands_temp = [i for i in range(1,AllNumber+1)]
    rands = rand(rands_temp, FirstPriceNumber+SecondPriceNumber+ThirdPriceNumber+OtherPriceNumber)
    # print(rands_temp)
    textrander()

def inputer():
    try:
        global Excel_Path, AllNumber, FirstPriceNumber, SecondPriceNumber, ThirdPriceNumber, OtherPriceNumber, FirstPriceName, SecondPriceName, ThirdPriceName, OtherPriceName
        Excel_Path = Excel_Path
        AllNumber = int(AllNumber)
        FirstPriceNumber = int(FirstPriceNumber)
        SecondPriceNumber = int(SecondPriceNumber)
        ThirdPriceNumber = int(ThirdPriceNumber)
        OtherPriceNumber = int(OtherPriceNumber)
        FirstPriceName = FirstPriceName.strip('：')
        FirstPriceName = FirstPriceName.strip(':')
        FirstPriceName += '：'
        SecondPriceName = SecondPriceName.strip('：')
        SecondPriceName = SecondPriceName.strip(':')
        SecondPriceName += '：'
        ThirdPriceName = ThirdPriceName.strip('：')
        ThirdPriceName = ThirdPriceName.strip(':')
        ThirdPriceName += '：'
        OtherPriceName = OtherPriceName.strip('：')
        OtherPriceName = OtherPriceName.strip(':')
        OtherPriceName += '：'
        # print(FirstPriceNumber + ' ' + SecondPriceNumber + ' ' + ThirdPriceNumber + ' ' + OtherPriceNumber)
        rand_chooser()
    except:
        global showchooser
        showchooser = False
        messagebox.showerror('错误', '请检查输入的数据。')

def getallnumber(Excel_Path):
    try:
        names = excel_reader.open_workbook(r'%s' % Excel_Path)
    except:
        return
    names = names.sheet_by_name('Sheet1')
    n = 0
    while True:
        try:
            names.cell(n+1, 0).value

            n += 1
        except:
            return n

    # print(n)

def graphics_main():
    def filechoose():
        global chosefilename
        chosefilename = filedialog.askopenfilename(filetypes = [('Excel表格文件', '*.xlsx *.xls')])
        ExcelPathEntry.config(state = 'normal')
        ExcelPathEntry.delete(0, END)
        ExcelPathEntry.insert(0, chosefilename)
        ExcelPathEntry.config(state = 'disabled')
        AllNumberEntry.config(state = 'normal')
        AllNumberEntry.delete(0, END)
        try:
            AllNumberEntry.insert(0, getallnumber(chosefilename))
        except:
            return
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
            global Excel_Path, FirstPriceNumber, SecondPriceNumber, ThirdPriceNumber, OtherPriceNumber, AllNumber, FirstPriceName, SecondPriceName, ThirdPriceName, OtherPriceName
            Excel_Path = ExcelPathEntry.get()
            FirstPriceNumber = FirstPriceNumberEntry.get()
            SecondPriceNumber = SecondPriceNumberEntry.get()
            ThirdPriceNumber = ThirdPriceNumberEntry.get()
            OtherPriceNumber = OtherPriceNumberEntry.get()
            AllNumber = AllNumberEntry.get()
            FirstPriceName = FirstPriceNameEntry.get()
            SecondPriceName = SecondPriceNameEntry.get()
            ThirdPriceName = ThirdPriceNameEntry.get()
            OtherPriceName = OtherPriceNameEntry.get()
            inputer()
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
    FirstPriceNameEntry = Entry(font = ('', 15))
    FirstPriceNameEntry.grid(row = 2, column = 0)
    FirstPriceNameEntry.insert(0, "一等奖：")
    FirstPriceNumberEntry = Entry(font = ('', 20))
    FirstPriceNumberEntry.grid(row = 2, column = 1)
    SecondPriceNameEntry = Entry(font = ('', 15))
    SecondPriceNameEntry.grid(row = 3, column = 0)
    SecondPriceNameEntry.insert(0, "二等奖：")
    SecondPriceNumberEntry = Entry(font = ('', 20))
    SecondPriceNumberEntry.grid(row = 3, column = 1)
    ThirdPriceNameEntry = Entry(font = ('', 15))
    ThirdPriceNameEntry.grid(row = 4, column = 0)
    ThirdPriceNameEntry.insert(0, "三等奖：")
    ThirdPriceNumberEntry = Entry(font = ('', 20))
    ThirdPriceNumberEntry.grid(row = 4, column = 1)
    OtherPriceNameEntry = Entry(font = ('', 15))
    OtherPriceNameEntry.grid(row = 5, column = 0)
    OtherPriceNameEntry.insert(0, "鼓励奖：")
    OtherPriceNumberEntry = Entry(font = ('', 20))
    OtherPriceNumberEntry.grid(row = 5, column = 1)
    ShowPriceText = ScrolledText(font = ('', 15), width = 28, height = 13, state = 'disabled')
    ShowPriceText.grid(row = 6,column = 1)
    StartButton = Button(text = '开始抽奖', font = ('', 15),command = start)
    StartButton.grid(row = 7, column = 1, padx=5, pady=5)
    root.mainloop()

def graphics_welcome():
    def NextStep():
        global PriceNumber
        PriceNumber = PriceNumberEntry.get()
        root.destroy()
        print(PriceNumber)
        graphics_main()
    root = Tk()
    root.geometry('200x100')
    root.title('抽奖器')
    PriceNumberLabel = Label(font = ('', 15), text = '奖项数量:')
    PriceNumberLabel.grid(row = 0, column = 0)
    PriceNumberEntry = Entry(font = ('', 20), width = 14)
    PriceNumberEntry.grid(row = 1, column = 0)
    BeginButton = Button(text = '下一步', font = ('', 15), command = NextStep)
    BeginButton.grid(row = 2, column = 0)
    root.mainloop()

if __name__ == '__main__':
    graphics_welcome()