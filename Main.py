import xlrd as excel_reader
import xlwt as excel_writer
import platform
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
    global rands, Excel_Path, PriceNumber
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
    global out, n
    out = ExcelTitle + '的抽奖结果是:' + '\n'
    i = 0; n = 0
    while i < PriceNumber:
        global e
        name = 'PriceName' + str(i + 1)
        number = 'PriceNumber' + str(i + 1)
        exec('global e; e = n + %s' % (number))
        exec('global Price; Price = %s' % name)
        exec('pricewriter.write(i + 1, 0, %s, style)' % name)
        while n < e:
            global Price, rands
            if e - n == 1:
                Price += names.cell(rands[n], 0).value
            else:
                Price += names.cell(rands[n], 0).value + '、'
            pricewriter.write(i + 1, e - n, names.cell(rands[n], 0).value, style)
            n += 1
        if PriceNumber - n == 0:
            out += Price
        else:
            out += Price + '\n'
        # print(i,n,e)
        i += 1
    ClipBoardWrite(out)
    try:
        delete(ExcelName + '抽奖结果' + ' .xls')
    except:
        pass
    priceopener.save(ExcelName + '抽奖结果' + ' .xls')

def rand_chooser():
    global rands, AllNumber, PriceNumber,AllPriceNumber
    AllPriceNumber = 0
    n = 0
    while n < PriceNumber:
        # global AllPriceNumber
        # AllPriceNumber = 0
        number = 'PriceNumber' + str(n + 1)
        exec('global AllPriceNumber, %s; AllPriceNumber += %s' % (number, number))
        n += 1
    # global AllPriceNumber
    rands_temp = [i for i in range(1,AllNumber+1)]
    rands = rand(rands_temp, AllPriceNumber)
    # print(rands_temp)
    # print(rands)
    textrander()

def inputer():
    try:
        global Excel_Path, AllNumber, PriceNumber
        Excel_Path = Excel_Path
        AllNumber = int(AllNumber)
        n = 0
        while n < PriceNumber:
            name = 'PriceName' + str(n + 1)
            number = 'PriceNumber' + str(n + 1)
            exec('global %s; %s = int(%s)' % (number, number, number))
            exec('global %s; %s = %s.strip(\'：\')' % (name, name, name))
            exec('global %s; %s = %s.strip(\':\')' % (name, name, name))
            exec('global %s; %s += \'：\'' % (name, name))
            n += 1
        # print(PriceNumber)
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
    def back():
        global showchooser
        if showchooser:
            if messagebox.askokcancel('警告', '你已经抽过一次奖，返回抽奖会清楚上抽奖的结果，你确定要返回吗？'):
                showchooser = False
                back()
        else:
            root.destroy()
            graphics_welcome()

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
            global AllNumber
            AllNumber = AllNumberEntry.get()
            showchooser = True
            global Excel_Path
            Excel_Path = ExcelPathEntry.get()
            global PriceNumber
            n = 0
            while n < PriceNumber:
                name = 'PriceName' + str(n + 1)
                number = 'PriceNumber' + str(n + 1)
                name1 = 'PriceNumberEntry' + str(n + 1)
                name2 = 'PriceNameEntry' + str(n + 1)
                # exec('global %s, %s' % (name2, name1))
                exec('global %s; nameread = %s.get()' % (name2, name2))
                exec('global %s; numberread = %s.get()' % (name1, name1))
                exec('global %s; %s = nameread' % (name, name))
                exec('global %s; %s = numberread' % (number, number))
                # exec('print(%s)' % number)
                # exec('print(%s)' % name)
                n += 1
            inputer()
            ShowPriceText.config(state = 'normal')
            ShowPriceText.delete(0.0, END)
            ShowPriceText.insert(END, out)
            ShowPriceText.config(state = 'disabled')
    global PriceNumber
    root = Tk()
    if platform.system().lower() == 'Windows':
        height = 350 + PriceNumber * 26
    else:
        height = 350 + PriceNumber * 30
    root.geometry('600x%s' % height)
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
    n = 0
    # print(PriceNumber)
    while n < PriceNumber:
        name1 = 'PriceNumberEntry' + str(n + 1)
        name2 = 'PriceNameEntry' + str(n + 1)
        location = n + 2
        # exec('global %s, %s' % (name2, name1))
        exec('global %s; %s = Entry(font = (\'\', 15))' % (name2, name2))
        exec('%s.grid(row = %d, column = 0)' % (name2, location))
        exec('global %s; %s = Entry(font = (\'\', 15))' % (name1, name1))
        exec('%s.grid(row = %d, column = 1)' % (name1, location))
        if n == 0:
            exec('%s.insert(0, \'一等奖：\')' % name2)
        elif n == 1:
            exec('%s.insert(0, \'二等奖：\')' % name2)
        elif n == 2:
            exec('%s.insert(0, \'三等奖：\')' % name2)
        elif n == 3:
            exec('%s.insert(0, \'鼓励奖：\')' % name2)
        n += 1
    ShowPriceText = ScrolledText(font = ('', 15), width = 28, height = 13, state = 'disabled')
    ShowPriceText.grid(row = PriceNumber + 2, column = 1)
    BackButton = Button(text = '返回', font = ('', 15),command = back)
    BackButton.grid(row = PriceNumber + 3, column = 0, padx=5, pady=5)
    StartButton = Button(text = '开始抽奖', font = ('', 15),command = start)
    StartButton.grid(row = PriceNumber + 3, column = 1, padx=5, pady=5)
    root.mainloop()

def graphics_welcome():
    def NextStep():
        global PriceNumber
        try:
            PriceNumber = int(PriceNumberEntry.get())
            root.destroy()
            # print(PriceNumber)
            graphics_main()
        except:
            messagebox.showerror('错误', '请检查输入的数据!')
    root = Tk()
    root.geometry('200x100')
    root.title('抽奖器')
    PriceNumberLabel = Label(font = ('', 15), text = '奖项数量:')
    PriceNumberLabel.grid(row = 0, column = 0)
    PriceNumberEntry = Entry(font = ('', 20), width = 14)
    PriceNumberEntry.grid(row = 1, column = 0)
    PriceNumberEntry.insert(0, '4')
    BeginButton = Button(text = '下一步', font = ('', 15), command = NextStep)
    BeginButton.grid(row = 2, column = 0)
    root.mainloop()

if __name__ == '__main__':
    graphics_welcome()