//
//  ContentView.swift
//  lottery
//
//  Created by wqhqq on 2020/7/25.
//

import SwiftUI
import WidgetKit

var AllPrizesMember: Int = 0

struct page2_add: View {
    
    @ObservedObject var PrizeData: Prizes
    @State var selection: Int? = nil
    @State var showeditingpage = false
    @State var showRemoveButton = [Bool](repeating: false, count: 1000)
    @State var isSelected = [Bool](repeating: false, count: 1000)
    @State var showConfirmButton = [Bool](repeating: false, count: 1000)
    @State var isEditingMode = false
    @State var showAlert = false
    @State var selected: [Int] = []
    @State var showButton = true
    @State var isDone = true
    @State var prizeHead = 0
    @State var prizeEnd = 0
    @State var multiRemove = false
    @State var showSheet = false
    @State var rangeText = ""
    @State var showAlertUp = false
    //    var timer: Timer?
    var size: CGFloat = 65.0
    @State var selectedOne = -1
    @State var path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    var body: some View {
        return VStack {
            ZStack {
                BlurView()
                ScrollView(.vertical, showsIndicators: true){
                    VStack {
                        ForEach(PrizeData.PrizeList) {prize in
                            if !prize.isRemoved {
                                HStack {
                                    SingleCard(isDone: self.$isDone, showRemoveButton: self.$showRemoveButton, selected: self.$selected, isSelected: self.$isSelected, showConfirmButton: self.$showConfirmButton, index: prize.id, prizeHead: self.$prizeHead, prizeEnd: self.$prizeEnd, selectedOne: self.$selectedOne, multiRemove: self.$multiRemove)
                                        .environmentObject(self.PrizeData)
                                        .cornerRadius(10)
                                        .animation(.spring())
                                        .transition(.slide)
                                        .contextMenu(menuItems: /*@START_MENU_TOKEN@*/{
                                            Button(action: {
                                                withAnimation {
                                                    self.PrizeData.remove(index: prize.id)
                                                    self.prizeHead = self.PrizeData.head()
                                                    self.prizeEnd = self.PrizeData.end()
                                                }
                                            }) {
                                                HStack {
                                                    Image(systemName: "trash.fill")
                                                        .foregroundColor(Color("trash"))
                                                        .padding(.trailing)
                                                    Text(NSLocalizedString("RMT", comment: ""))
                                                        .foregroundColor(.red)
                                                        .background(Color.red)
                                                }
                                            }
                                            if self.prizeHead != prize.id {
                                                Button(action: {
                                                    self.PrizeData.move(from: prize.id, to: self.PrizeData.upNearBy(index: prize.id))
                                                }) {
                                                    Text("Move up")
                                                    Image(systemName: "chevron.up")
                                                        .foregroundColor(Color("trash"))
                                                        .padding([.top, .bottom])
                                                        .imageScale(.large)
                                                }
                                            }
                                            else {
                                                Button(action: {
                                                    self.showAlertUp = true
                                                }) {
                                                    Text("Move up")
                                                    Image(systemName: "chevron.up")
                                                        .foregroundColor(Color("arrow.grey"))
                                                        .padding([.top, .bottom])
                                                        .imageScale(.large)
                                                }
                                            }
                                            if self.prizeEnd != prize.id {
                                                Button(action: {
                                                    self.PrizeData.move(from: prize.id, to: self.PrizeData.downNearBy(index: prize.id))
                                                }) {
                                                    Text("Move down")
                                                    Image(systemName: "chevron.down")
                                                        .foregroundColor(Color("trash"))
                                                        .padding([.bottom])
                                                        .imageScale(.large)
                                                }
                                            }
                                            else {
                                                Button(action: {}) {
                                                    Text("Move down")
                                                    Image(systemName: "chevron.down")
                                                        .foregroundColor(Color("arrow.grey"))
                                                        .padding([.bottom])
                                                        .imageScale(.large)
                                                }
                                            }
                                        }/*@END_MENU_TOKEN@*/)
                                }
                                .animation(.spring())
                                .transition(.slide)
                            }
                        }
                        .animation(.spring())
                        .transition(.slide)
                    }
                    //                    .transition(.slide)
                    
                }.padding(.horizontal)
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        if self.selectedOne != -1 && !self.isDone {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .background(Color(.sRGB, white: 1, opacity: 0.2))
                                    .frame(width: 40, height: 80)
                                    .cornerRadius(50)
                                    .shadow(color: Color("Shadow"), radius: 10)
                                VStack() {
                                    if self.prizeHead != self.selectedOne {
                                        Button(action: {
                                            self.PrizeData.move(from: self.selectedOne, to: self.PrizeData.upNearBy(index: self.selectedOne))
                                            self.selectedOne = self.PrizeData.upNearBy(index: self.selectedOne)
                                        }) {
                                            Image(systemName: "chevron.up")
                                                .foregroundColor(Color("trash"))
                                                .padding([.top, .bottom])
                                                .imageScale(.large)
                                        }
                                    }
                                    else {
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(Color("arrow.grey"))
                                            .padding([.top, .bottom])
                                            .imageScale(.large)
                                    }
                                    if self.prizeEnd != self.selectedOne {
                                        Button(action: {
                                            self.PrizeData.move(from: self.selectedOne, to: self.PrizeData.downNearBy(index: self.selectedOne))
                                            self.selectedOne = self.PrizeData.downNearBy(index: self.selectedOne)
                                        }) {
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(Color("trash"))
                                                .padding([.bottom])
                                                .imageScale(.large)
                                        }
                                    }
                                    else {
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color("arrow.grey"))
                                            .padding([.bottom])
                                            .imageScale(.large)
                                    }
                                }
                                
                            }.padding([.bottom, .leading])
                        }
                        
                        HStack{
                            Spacer()
                            if self.showButton && !multiRemove {
                                HStack {
                                    NavigationLink(destination: page3_animationPlay(filepath: self.$path).environmentObject(self.PrizeData), tag: 1, selection: $selection) {
                                        Button(action: {
                                            AllPrizesMember = APM_ccltor(data: self.PrizeData.PrizeList_cacu)
                                            var isUsed = [Bool](repeating: false, count: 1000)
                                            readyToCopy = ""
                                            if AllPrizesMember <= MemberNumber {
                                                var i = 0, j = 0
                                                while i < self.PrizeData.PrizeList_cacu.count {
                                                    j = 0
                                                    var names = [String](), numbers = [Int](), number = 0, rands = [Int]()
                                                    self.PrizeData.PrizeList_cacu[i].Lottery_result = ""
                                                    if self.PrizeData.PrizeList_cacu[i].minCmd == nil &&
                                                        self.PrizeData.PrizeList_cacu[i].maxCmd == nil {
                                                        var k = 0
                                                        while k < MemberNames.count {
                                                            if !isUsed[k] {
                                                                names.append(MemberNames[k])
                                                            }
                                                            k += 1
                                                        }
                                                        number = self.PrizeData.PrizeList_cacu[i].PrizeMember
                                                        k = 0
                                                        while k < names.count {
                                                            numbers.append(k)
                                                            k += 1
                                                        }
                                                    }
                                                    else {
                                                        number = self.PrizeData.PrizeList_cacu[i].PrizeMember
                                                        while j < MemberNumber {
                                                            if addCmd[j] >= self.PrizeData.PrizeList_cacu[i].minCmd!
                                                                && addCmd[j] <= self.PrizeData.PrizeList_cacu[i].maxCmd!
                                                                && !isUsed[j] {
                                                                names.append(MemberNames[j])
                                                                numbers.append(j)
                                                            }
                                                            j += 1
                                                        }
                                                    }
                                                    print(numbers)
                                                    print(names)
                                                    print(addCmd)
                                                    print(number)
                                                    if number <= names.count {
                                                        rands = Random(start: 1, end: number + 1, Members: names.count)
                                                    }
                                                    else {
                                                        self.showAlert = true
                                                        break
                                                    }
                                                    j = 0
                                                    readyToCopy += self.PrizeData.PrizeList_cacu[i].PrizeName + ","
                                                    while j < number {
                                                        if j == number - 1 {
                                                            self.PrizeData.PrizeList_cacu[i].Lottery_result += names[rands[j] - 1]
                                                            readyToCopy += names[rands[j] - 1]
                                                        }
                                                        else {
                                                            self.PrizeData.PrizeList_cacu[i].Lottery_result += names[rands[j] - 1] + "、"
                                                            readyToCopy += names[rands[j] - 1] + ","
                                                        }
                                                        isUsed[numbers[rands[j] - 1]] = true
                                                        j += 1
                                                    }
                                                    readyToCopy += "\n"
                                                    i += 1
                                                }
                                                PrizeData.save()
                                                path.appendPathComponent("Lottery Result - \(getDate()).csv")
                                                WidgetCenter.shared.reloadAllTimelines()
                                                try! readyToCopy.write(to: path, atomically: true, encoding: .utf8)
                                                self.selection = 1
                                            }
                                            else {
                                                self.showAlert = true
                                            }
                                        })
                                        {
                                            btnAdd()
                                        }
                                        .alert(isPresented: self.$showAlert) {
                                            Alert(title: Text("Fatal Error"), message: Text("Too much winners"), dismissButton: .default(Text("OK")))
                                        }
                                    }
                                    Button(action: {
                                        self.showeditingpage = true
                                    }){
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .foregroundColor(.blue)
                                            .frame(width: self.size, height: self.size)
                                            .padding(.horizontal, 10)
                                            .shadow(color: Color("Shadow"), radius: 10)
                                    }
                                    .sheet(isPresented: self.$showeditingpage) {
                                        EditingPage(prizeHead: self.$prizeHead, prizeEnd: self.$prizeEnd, showADDCTF: false)
                                            .environmentObject(self.PrizeData)
                                    }
                                }
                            }
                        }.padding(.bottom)
                    }
                }
            }.navigationBarTitle(NSLocalizedString("ADDT", comment: ""))
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: multi_Remove(multiRemove: self.$multiRemove, showSheet: self.$showSheet, prizeHead: self.$prizeHead, prizeEnd: self.$prizeEnd, selected: self.$selected).environmentObject(self.PrizeData),
                            trailing: editingButton(isEditingMode: self.$isEditingMode, showButton: self.$showButton, showRemoveButton: self.$showRemoveButton, selected: self.$selected, isDone: self.$isDone, multiRemove: self.$multiRemove, selectedOne: self.$selectedOne, showConfirmButton: self.$showConfirmButton))
    }
}

struct SingleCard: View {
    @State var showeditingpage = false
    @EnvironmentObject var PrizeData: Prizes
    @Binding var isDone: Bool
    @Binding var showRemoveButton: [Bool]
    @Binding var selected: [Int]
    @Binding var isSelected: [Bool]
    @Binding var showConfirmButton: [Bool]
    var index: Int?
    @Binding var prizeHead: Int
    @Binding var prizeEnd: Int
    var timer = Timer.publish(every: 0.1, on: .main, in: .common)
    @Binding var selectedOne: Int
    @Binding var multiRemove: Bool
    let uiimage = UIImage(systemName: "pause")!
    @State var range = ""
    var body: some View {
        DispatchQueue.main.async {
            if self.PrizeData.PrizeList[index!].enabledCmds && self.PrizeData.PrizeList[index!].maxCmd != nil && self.PrizeData.PrizeList[index!].minCmd != nil {
                if self.PrizeData.PrizeList[index!].minCmd == self.PrizeData.PrizeList[index!].maxCmd {
                    range = "(=" + String(self.PrizeData.PrizeList[index!].minCmd!) + ")"
                }
                else {
                    range = "(" + String(self.PrizeData.PrizeList[index!].minCmd!) + "≤,≤" + String(self.PrizeData.PrizeList[index!].maxCmd!) + ")"
                }
            }
        }
        return HStack {
            HStack {
                if self.isDone == false {
                    if self.showRemoveButton[index!] {
                        Button(action: {
                            self.showConfirmButton[self.index!] = true
                            self.showRemoveButton[self.index!] = false
                        }){
                            Image(systemName: "minus.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.white)
                                .padding(.trailing)
                        }
                        .padding([.leading, .bottom])
                    }
                }
                HStack {
                    Rectangle()
                        .frame(width: 6)
                        .foregroundColor(.white)
                    Button(action: {
                        if self.showConfirmButton[self.index!] == true {
                            self.showConfirmButton[self.index!] = false
                            self.showRemoveButton[self.index!] = true
                            print(self.multiRemove)
                        }
                        if self.isDone == true && !self.multiRemove {
                            self.showeditingpage = true
                        }
                    }){
                        HStack {
                            VStack(alignment: .leading, spacing: 6.0) {
                                HStack {
                                    Text(PrizeData.PrizeList[index!].PrizeName)
                                        .font(.headline)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                    Text(range)
                                        .font(.headline)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                }
                                Text("\(NSLocalizedString("QTT", comment: ""))\(PrizeData.PrizeList[index!].PrizeMember)")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            if self.isDone == false {
                                if showConfirmButton[self.index!] == true {
                                    Button(action: {
                                        withAnimation {
                                            self.PrizeData.remove(index: self.index!)
                                            self.prizeHead = self.PrizeData.head()
                                            self.prizeEnd = self.PrizeData.end()
                                            self.showConfirmButton[self.index!] = false
                                            self.showRemoveButton[self.index!] = true
                                            self.selectedOne = -1
                                            if self.selected.firstIndex(where: {$0 == self.index}) != nil {
                                                self.selected.remove(at: self.selected.firstIndex(where: {$0 == self.index})!)
                                            }
                                            if self.selected.count == 0 {
                                                self.multiRemove = false
                                            }
                                        }
                                    }) {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.red)
                                                .frame(width: 80)
                                            Text(NSLocalizedString("RMT", comment: ""))
                                                .foregroundColor(.white)
                                                .fontWeight(.heavy)
                                        }
                                    }
                                }
                                
                            }
                            if isDone == false && !multiRemove && !showConfirmButton[self.index!] {
                                Button(action: {
                                    if self.selectedOne == self.index! {
                                        self.multiRemove = true
                                        self.selected.append(self.index!)
                                        self.selectedOne = -1
                                    }
                                    else {
                                        self.selectedOne = self.index!
                                    }
                                }) {
                                    if self.selectedOne == self.index! {
                                        ZStack {
                                            Image(systemName: "circle")
                                                .imageScale(.large)
                                                .foregroundColor(Color("trash"))
                                            Image(systemName: "circle.fill")
                                                .imageScale(.small)
                                                .foregroundColor(Color("trash"))
                                        }
                                    }
                                    else {
                                        Image(systemName: "circle")
                                            .imageScale(.large)
                                            .foregroundColor(Color("trash"))
                                    }
                                }.padding(.trailing)
                            }
                            
                            if self.multiRemove && !self.showConfirmButton[self.index!] {
                                Button(action: {
                                    if self.selected.firstIndex(where: {$0 == self.index}) == nil {
                                        self.selected.append(self.index!)
                                    }
                                    else {
                                        self.selected.remove(at: self.selected.firstIndex(where: {$0 == self.index})!)
                                    }
                                    if self.selected.count == 0 {
                                        self.multiRemove = false
                                    }
                                }) {
                                    Image(systemName: self.selected.firstIndex(where: {$0 == self.index}) != nil ? "checkmark.circle.fill":"circle")
                                        .imageScale(.large)
                                        .padding(.trailing)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                    }.sheet(isPresented: $showeditingpage) {
                        EditingPage(prizename: self.PrizeData.PrizeList[self.index!].PrizeName, prizequota: String(self.PrizeData.PrizeList[self.index!].PrizeMember), index: self.index, prizeHead: self.$prizeHead, prizeEnd: self.$prizeEnd, showADDCTF: self.PrizeData.PrizeList[self.index!].enabledCmds, maxCmd: self.PrizeData.PrizeList[self.index!].maxCmd == nil ? "": String(self.PrizeData.PrizeList[self.index!].maxCmd!), minCmd: self.PrizeData.PrizeList[self.index!].minCmd == nil ? "": String(self.PrizeData.PrizeList[self.index!].minCmd!))
                            .environmentObject(self.PrizeData)
                    }
                }.frame(height: 80)
                .background(Color(.sRGB, white: 1, opacity: 0.2))
                .cornerRadius(10)
                .padding(.bottom)
                .shadow(color: Color("Shadow"), radius: 10, x: 1, y: 3)
            }
        }
    }
}

struct btnAdd: View {
    var size: CGFloat = 65.0
    var body: some View {
        ZStack{
            Group {
                Circle()
                    .fill(Color.red)
                    .shadow(color: Color("Shadow"), radius: 10)
            }.frame(width: self.size, height: self.size)
            Group {
                Text(NSLocalizedString("GOB", comment: ""))
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        page2_add(PrizeData: Prizes())
    }
}

struct backButton_p2: View {
    @State var back: Int? = nil
    var origin_names: String = ""
    var body: some View {
        NavigationLink(destination: ContentView_back(), tag: 1, selection: $back) {
            HStack {
                Button(action: {
                    self.back = 1
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
                Spacer()
                Text(NSLocalizedString("NBT1", comment: ""))
                    .font(Font.system(size: 22))
                    .foregroundColor(.white)
                Spacer()
            }
        }.transition(.slide)
    }
}

struct multi_Remove: View {
    @Binding var multiRemove: Bool
    @Binding var showSheet: Bool
    @Binding var prizeHead: Int
    @Binding var prizeEnd: Int
    @Binding var selected: [Int]
    @EnvironmentObject var PrizeData: Prizes
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                backButton_p2()
                if self.multiRemove == true {
                    Button(action : {
                        self.showSheet = true
                    }) {
                        Image(systemName: "trash.fill")
                            .imageScale(.large)
                            .padding(.trailing)
                            .foregroundColor(.white)
                    }
                    .actionSheet(isPresented: self.$showSheet) {
                        ActionSheet(title: Text(NSLocalizedString("RMT", comment: "")), message: Text(NSLocalizedString("CRMT", comment: "")),
                                    buttons: [.destructive(Text(NSLocalizedString("RMT", comment: ""))) {
                                        self.PrizeData.removeMore(index: self.selected)
                                        self.prizeHead = self.PrizeData.head()
                                        self.prizeEnd = self.PrizeData.end()
                                        self.selected = []
                                        self.multiRemove = false
                                    }, .default(Text(NSLocalizedString("CANL", comment: "")))])
                    }
                }
            }
        }
    }
}

struct editingButton: View {
    @Binding var isEditingMode: Bool
    @Binding var showButton: Bool
    @Binding var showRemoveButton: [Bool]
    @Binding var selected: [Int]
    @Binding var isDone: Bool
    @Binding var multiRemove: Bool
    @Binding var selectedOne: Int
    @Binding var showConfirmButton: [Bool]
    var body: some View {
        Button(action: {
            self.showButton.toggle()
            var i = 0
            while i < self.showRemoveButton.count {
                if self.isEditingMode {
                    self.showRemoveButton[i] = false
                }
                else {
                    self.showRemoveButton[i] = true
                }
                i += 1
            }
            i = 0
            self.isEditingMode.toggle()
            self.selected.removeAll()
            self.isDone.toggle()
            if isDone {
                while i < self.showConfirmButton.count {
                    self.showConfirmButton[i] = false
                    i += 1
                }
            }
            self.multiRemove = false
            i = 0
            self.selectedOne = -1
        }){
            Text(isEditingMode ? NSLocalizedString("DONE", comment: ""):NSLocalizedString("EDIT", comment: ""))
                .font(.custom("", size: 20))
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding(.trailing)
        }
    }
}
