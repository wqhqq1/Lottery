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
english = False

def textrander():
    global english
    if english:
        global rands, Excel_Path, prizeNumber
        names = excel_reader.open_workbook(r'%s' % Excel_Path)
        names = names.sheet_by_name('Sheet1')
        prizeopener = excel_writer.Workbook(encoding='gbk')
        prizewriter = prizeopener.add_sheet('Sheet1', cell_overwrite_ok=True)
        excel_border = excel_writer.Borders()
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
        prizewriter.write(0, 0, ExcelTitle + '\'s lottery result', style_title)
        global out, n
        out = ExcelTitle + '\'s lottery result' + '\n'
        i = 0;
        n = 0
        while i < prizeNumber:
            global e
            name = 'prizeName' + str(i + 1)
            number = 'prizeNumber' + str(i + 1)
            exec('global e; e = n + %s' % (number))
            exec('global prize; prize = %s' % name)
            exec('prizewriter.write(i + 1, 0, %s, style)' % name)
            while n < e:
                global prize, rands
                if e - n == 1:
                    prize += names.cell(rands[n], 0).value
                else:
                    prize += names.cell(rands[n], 0).value + '、'
                prizewriter.write(i + 1, e - n, names.cell(rands[n], 0).value, style)
                n += 1
            if prizeNumber - n == 0:
                out += prize
            else:
                out += prize + '\n'
            # print(i,n,e)
            i += 1
        ClipBoardWrite(out)
        try:
            delete(ExcelName + '\'s lottery result' + ' .xls')
        except:
            pass
        prizeopener.save(ExcelName + '\'s lottery result' + ' .xls')
    else:
        names = excel_reader.open_workbook(r'%s' % Excel_Path)
        names = names.sheet_by_name('Sheet1')
        prizeopener = excel_writer.Workbook(encoding='gbk')
        prizewriter = prizeopener.add_sheet('Sheet1', cell_overwrite_ok=True)
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
        prizewriter.write(0, 0, ExcelTitle + '的抽奖结果', style_title)
        out = ExcelTitle + '的抽奖结果是:' + '\n'
        i = 0; n = 0
        while i < prizeNumber:
            name = 'prizeName' + str(i + 1)
            number = 'prizeNumber' + str(i + 1)
            exec('global e; e = n + %s' % (number))
            exec('global prize; prize = %s' % name)
            exec('prizewriter.write(i + 1, 0, %s, style)' % name)
            while n < e:
                if e - n == 1:
                    prize += names.cell(rands[n], 0).value
                else:
                    prize += names.cell(rands[n], 0).value + '、'
                prizewriter.write(i + 1, e - n, names.cell(rands[n], 0).value, style)
                n += 1
            if prizeNumber - n == 0:
                out += prize
            else:
                out += prize + '\n'
            # print(i,n,e)
            i += 1
        ClipBoardWrite(out)
        try:
            delete(ExcelName + '抽奖结果' + ' .xls')
        except:
            pass
        prizeopener.save(ExcelName + '抽奖结果' + ' .xls')

def rand_chooser():
    global rands, AllNumber, prizeNumber,AllprizeNumber
    AllprizeNumber = 0
    n = 0
    while n < prizeNumber:
        # global AllprizeNumber
        # AllprizeNumber = 0
        number = 'prizeNumber' + str(n + 1)
        exec('global AllprizeNumber, %s; AllprizeNumber += %s' % (number, number))
        n += 1
    # global AllprizeNumber
    rands_temp = [i for i in range(1,AllNumber+1)]
    rands = rand(rands_temp, AllprizeNumber)
    # print(rands_temp)
    # print(rands)
    textrander()

def inputer():
    global english
    if english:
        try:
            global Excel_Path, AllNumber, prizeNumber
            Excel_Path = Excel_Path
            AllNumber = int(AllNumber)
            n = 0
            while n < prizeNumber:
                name = 'prizeName' + str(n + 1)
                number = 'prizeNumber' + str(n + 1)
                exec('global %s; %s = int(%s)' % (number, number, number))
                exec('global %s; %s = %s.strip(\'：\')' % (name, name, name))
                exec('global %s; %s = %s.strip(\':\')' % (name, name, name))
                exec('global %s; %s += \'：\'' % (name, name))
                n += 1
            # print(prizeNumber)
            rand_chooser()
        except:
            global showchooser
            showchooser = False
            messagebox.showerror('Error', 'Please check the data.')
    else:
        try:
            Excel_Path = Excel_Path
            AllNumber = int(AllNumber)
            n = 0
            while n < prizeNumber:
                name = 'prizeName' + str(n + 1)
                number = 'prizeNumber' + str(n + 1)
                exec('global %s; %s = int(%s)' % (number, number, number))
                exec('global %s; %s = %s.strip(\'：\')' % (name, name, name))
                exec('global %s; %s = %s.strip(\':\')' % (name, name, name))
                exec('global %s; %s += \'：\'' % (name, name))
                n += 1
            # print(prizeNumber)
            rand_chooser()
        except:
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
    global english
    if english:
        def back():
            global showchooser
            if showchooser:
                if messagebox.askokcancel('Warning', 'You have already do lottery before,'
                                                     ' the result will clear after you back, are you sure about that?'):
                    showchooser = False
                    back()
            else:
                root.destroy()
                graphics_welcome()

        def filechoose():
            global chosefilename
            chosefilename = filedialog.askopenfilename(filetypes=[('Excel Table File', '*.xlsx *.xls')])
            ExcelPathEntry.config(state='normal')
            ExcelPathEntry.delete(0, END)
            ExcelPathEntry.insert(0, chosefilename)
            ExcelPathEntry.config(state='disabled')
            AllNumberEntry.config(state='normal')
            AllNumberEntry.delete(0, END)
            try:
                AllNumberEntry.insert(0, getallnumber(chosefilename))
            except:
                return
            AllNumberEntry.config(state='disabled')

        def start():
            global out
            global showchooser
            if showchooser:
                if messagebox.askokcancel('Warning', 'You have already do lottery before, '
                                                     'data will clear after do lottery again, '
                                                     'are you sure about that?'):
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
                global prizeNumber
                n = 0
                while n < prizeNumber:
                    name = 'prizeName' + str(n + 1)
                    number = 'prizeNumber' + str(n + 1)
                    name1 = 'prizeNumberEntry' + str(n + 1)
                    name2 = 'prizeNameEntry' + str(n + 1)
                    # exec('global %s, %s' % (name2, name1))
                    exec('global %s; nameread = %s.get()' % (name2, name2))
                    exec('global %s; numberread = %s.get()' % (name1, name1))
                    exec('global %s; %s = nameread' % (name, name))
                    exec('global %s; %s = numberread' % (number, number))
                    # exec('print(%s)' % number)
                    # exec('print(%s)' % name)
                    n += 1
                inputer()
                ShowprizeText.config(state='normal')
                ShowprizeText.delete(0.0, END)
                ShowprizeText.insert(END, out)
                ShowprizeText.config(state='disabled')

        global prizeNumber
        root = Tk()
        if platform.system().lower() == 'Windows':
            height = 350 + prizeNumber * 26
        else:
            height = 350 + prizeNumber * 30
        root.geometry('700x%s' % height)
        root.title('Lottery')
        ExcelPathLabel = Label(text='Choose a Excel table file', font=('', 15))
        ExcelPathLabel.grid(row=0, column=0)
        ExcelPathEntry = Entry(font=('', 20), state='disabled')
        ExcelPathEntry.grid(row=0, column=1)
        ExcelPathButton = Button(text='Choose file', font=('', 15), command=filechoose)
        ExcelPathButton.grid(row=0, column=2)
        AllNumberLabel = Label(text='Will do lottery number:', font=('', 15))
        AllNumberLabel.grid(row=1, column=0)
        AllNumberEntry = Entry(font=('', 20), state='disabled')
        AllNumberEntry.grid(row=1, column=1)
        n = 0
        # print(prizeNumber)
        while n < prizeNumber:
            name1 = 'prizeNumberEntry' + str(n + 1)
            name2 = 'prizeNameEntry' + str(n + 1)
            location = n + 2
            # exec('global %s, %s' % (name2, name1))
            exec('global %s; %s = Entry(font = (\'\', 15))' % (name2, name2))
            exec('%s.grid(row = %d, column = 0)' % (name2, location))
            exec('global %s; %s = Entry(font = (\'\', 15))' % (name1, name1))
            exec('%s.grid(row = %d, column = 1)' % (name1, location))
            if n == 0:
                exec('%s.insert(0, \'First prize:\')' % name2)
            elif n == 1:
                exec('%s.insert(0, \'Second prize:\')' % name2)
            elif n == 2:
                exec('%s.insert(0, \'Third prize:\')' % name2)
            elif n == 3:
                exec('%s.insert(0, \'Encouragement prize:\')' % name2)
            n += 1
        ShowprizeText = ScrolledText(font=('', 15), width=28, height=13, state='disabled')
        ShowprizeText.grid(row=prizeNumber + 2, column=1)
        BackButton = Button(text='Back', font=('', 15), command=back)
        BackButton.grid(row=prizeNumber + 3, column=0, padx=5, pady=5)
        StartButton = Button(text='Start Lottery', font=('', 15), command=start)
        StartButton.grid(row=prizeNumber + 3, column=1, padx=5, pady=5)
        root.mainloop()
    else:
        def back():
            global showchooser
            if showchooser:
                if messagebox.askokcancel('警告', '你已经抽过一次奖，返回抽奖会清除上抽奖的结果，你确定要返回吗？'):
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
                global prizeNumber
                n = 0
                while n < prizeNumber:
                    name = 'prizeName' + str(n + 1)
                    number = 'prizeNumber' + str(n + 1)
                    name1 = 'prizeNumberEntry' + str(n + 1)
                    name2 = 'prizeNameEntry' + str(n + 1)
                    # exec('global %s, %s' % (name2, name1))
                    exec('global %s; nameread = %s.get()' % (name2, name2))
                    exec('global %s; numberread = %s.get()' % (name1, name1))
                    exec('global %s; %s = nameread' % (name, name))
                    exec('global %s; %s = numberread' % (number, number))
                    # exec('print(%s)' % number)
                    # exec('print(%s)' % name)
                    n += 1
                inputer()
                ShowprizeText.config(state = 'normal')
                ShowprizeText.delete(0.0, END)
                ShowprizeText.insert(END, out)
                ShowprizeText.config(state = 'disabled')
        root = Tk()
        if platform.system().lower() == 'Windows':
            height = 350 + prizeNumber * 26
        else:
            height = 350 + prizeNumber * 30
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
        # print(prizeNumber)
        while n < prizeNumber:
            name1 = 'prizeNumberEntry' + str(n + 1)
            name2 = 'prizeNameEntry' + str(n + 1)
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
        ShowprizeText = ScrolledText(font = ('', 15), width = 28, height = 13, state = 'disabled')
        ShowprizeText.grid(row = prizeNumber + 2, column = 1)
        BackButton = Button(text = '返回', font = ('', 15),command = back)
        BackButton.grid(row = prizeNumber + 3, column = 0, padx=5, pady=5)
        StartButton = Button(text = '开始抽奖', font = ('', 15),command = start)
        StartButton.grid(row = prizeNumber + 3, column = 1, padx=5, pady=5)
        root.mainloop()

def graphics_welcome():
    global english
    if english:
        def NextStep():
            global prizeNumber
            try:
                prizeNumber = int(prizeNumberEntry.get())
                root.destroy()
                # print(prizeNumber)
                graphics_main()
            except:
                messagebox.showerror('Error', 'Please check the data !')

        def back():
            root.destroy()
            language_chooser()

        root = Tk()
        root.geometry('200x100')
        root.title('Lottery')
        prizeNumberLabel = Label(font=('', 15), text='Number of prizes:')
        prizeNumberLabel.grid(row=0, column=0)
        prizeNumberEntry = Entry(font=('', 20), width=14)
        prizeNumberEntry.grid(row=1, column=0)
        prizeNumberEntry.insert(0, '4')
        BeginButton = Button(text='Next', font=('', 15), command=NextStep)
        BeginButton.grid(row=2, column=0, sticky=E)
        BackButton = Button(text='Back', font=('', 15), command=back)
        BackButton.grid(row=2, column=0, sticky=W)
        root.mainloop()
    else:
        def NextStep():
            global prizeNumber
            try:
                prizeNumber = int(prizeNumberEntry.get())
                root.destroy()
                # print(prizeNumber)
                graphics_main()
            except:
                messagebox.showerror('错误', '请检查输入的数据!')
        def back():
            root.destroy()
            language_chooser()
        root = Tk()
        root.geometry('200x100')
        root.title('抽奖器')
        prizeNumberLabel = Label(font = ('', 15), text = '奖项数量:')
        prizeNumberLabel.grid(row = 0, column = 0)
        prizeNumberEntry = Entry(font = ('', 20), width = 14)
        prizeNumberEntry.grid(row = 1, column = 0)
        prizeNumberEntry.insert(0, '4')
        BeginButton = Button(text = '下一步', font = ('', 15), command = NextStep)
        BeginButton.grid(row = 2, column = 0, sticky = E)
        BackButton = Button(text = '返回', font = ('', 15), command = back)
        BackButton.grid(row = 2, column = 0, sticky = W)
        root.mainloop()

def language_chooser():
    def load_chinese():
        root.destroy()
        global english
        english = False
        graphics_welcome()
    def load_english():
        root.destroy()
        global english
        english = True
        graphics_welcome()
    root = Tk()
    root.geometry('500x100')
    root.title('')
    TitleLabel = Label(text = 'Choose language/选择语言', font = ('', 20))
    TitleLabel.grid(row = 0, column = 0)
    ChineseButton = Button(text = '简体中文', font = ('', 20), command = load_chinese)
    ChineseButton.grid(row = 1, column = 0)
    EnglishButton = Button(text = 'English', font = ('', 20), command = load_english)
    EnglishButton.grid(row = 1, column = 1)
    root.mainloop()

if __name__ == '__main__':
    language_chooser()