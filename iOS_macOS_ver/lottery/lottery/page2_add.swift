//
//  ContentView.swift
//  lottery
//
//  Created by wqhqq on 2020/7/25.
//

import SwiftUI

var AllPrizesMember: Int = 0, rands = [Int]()

struct page2_add: View {
    
    @ObservedObject var PrizeData = Prizes()
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
    //    var timer: Timer?
    var size: CGFloat = 65.0
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if isEditingMode {
                    Button(action : {
                        self.showAlert = true
                    }) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(Color("trash"))
                            .imageScale(.large)
                            .padding(.trailing)
                    }
                    .actionSheet(isPresented: self.$showAlert) {
                        ActionSheet(title: Text(NSLocalizedString("RMT", comment: "")), message: Text(NSLocalizedString("CRMT", comment: "")),
                                    buttons: [.destructive(Text(NSLocalizedString("RMT", comment: ""))) {
                                        self.PrizeData.removeMore(index: self.selected)
                                        self.selected = []
                                        }])
                    }
                }
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
                    self.isEditingMode.toggle()
                    self.selected.removeAll()
                    self.isDone.toggle()
                    i = 0
                    while i < self.isSelected.count {
                        self.isSelected[i] = false
                        self.showConfirmButton[i] = false
                        i += 1
                    }
                }){
                    Text(isEditingMode ? NSLocalizedString("DONE", comment: ""):NSLocalizedString("EDIT", comment: ""))
                        .font(.custom("", size: 20))
                        .fontWeight(.heavy)
                        .padding(.trailing)
                }
            }
            ZStack {
                ScrollView(.vertical, showsIndicators: true){
                    VStack {
                        ForEach(PrizeData.PrizeList) {prize in
                            if !prize.isRemoved {
                                HStack {
                                    SingleCard(isDone: self.$isDone, showRemoveButton: self.$showRemoveButton, selected: self.$selected, isSelected: self.$isSelected, showConfirmButton: self.$showConfirmButton, index: prize.id)
                                        .environmentObject(self.PrizeData)
                                        .animation(.spring())
                                        .transition(.slide)
                                }.animation(.spring())
                                    .transition(.slide)
                            }
                        }.animation(.spring())
                            .transition(.slide)
                    }
                    //                    .transition(.slide)
                    
                }.padding(.horizontal)
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        if self.showButton {
                            HStack {
                                NavigationLink(destination: page3_animationPlay().environmentObject(self.PrizeData), tag: 1, selection: $selection) {
                                    Button(action: {
                                        AllPrizesMember = APM_ccltor(data: self.PrizeData.PrizeList_cacu)
                                        if AllPrizesMember <= MemberNumber {
                                            rands = Random(start: 1, end: AllPrizesMember + 1, Members: MemberNumber)
                                            var i = 0, j = 0
                                            while i < self.PrizeData.PrizeList_cacu.count {
                                                self.PrizeData.PrizeList_cacu[i].Lottery_result = ""
                                                while j < self.PrizeData.PrizeList_cacu[i].PrizeM {
                                                    self.PrizeData.PrizeList_cacu[i].Lottery_result += "\n" + MemberNames[rands[j] - 1] + " "
                                                    j += 1
                                                }
                                                i += 1
                                            }
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
                                    EditingPage()
                                        .environmentObject(self.PrizeData)
                                }
                            }.padding(.bottom)
                        }
                    }
                }
            }.navigationBarTitle(NSLocalizedString("ADDT", comment: ""))
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton_p2())
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
    //    @State var showAlert = false
    var index: Int?
    var body: some View {
        HStack {
            if self.isDone == false {
                if self.showRemoveButton[index!] {
                    Button(action: {
                        self.showConfirmButton[self.index!] = true
                        self.showRemoveButton[self.index!] = false
                        if self.selected.firstIndex(where: {$0 == self.index}) != nil {
                            self.selected.remove(at: self.selected.firstIndex(where: {$0 == self.index})!)
                        }
                    }){
                        Image(systemName: "minus.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.red)
                            .padding(.trailing)
                    }
                    .padding([.leading, .bottom])
                }
            }
            HStack {
                Rectangle()
                    .frame(width: 6)
                    .foregroundColor(.blue)
                Button(action: {
                    if self.showConfirmButton[self.index!] == true {
                        self.showConfirmButton[self.index!] = false
                        self.showRemoveButton[self.index!] = true
                    }
                    if self.isDone == true {
                        self.showeditingpage = true
                    }
                }){
                    Group {
                        HStack {
                            VStack(alignment: .leading, spacing: 6.0) {
                                Text(PrizeData.PrizeList[index!].PrizeName)
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.black)
                                Text("\(NSLocalizedString("QTT", comment: ""))\(PrizeData.PrizeList[index!].PrizeMember)")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            if self.isDone == false {
                                if showRemoveButton[index!]{
                                    Button(action: {
                                        if self.selected.firstIndex(where: {$0 == self.index}) == nil {
                                            self.selected.append(self.index!)
                                        }
                                        else {
                                            self.selected.remove(at: self.selected.firstIndex(where: {$0 == self.index})!)
                                        }
                                    }) {
                                        Image(systemName: self.selected.firstIndex(where: {$0 == self.index}) != nil ? "checkmark.circle.fill":"circle")
                                            .imageScale(.large)
                                            .foregroundColor(.black)
                                            .padding(.trailing)
                                    }
                                }
                                else {
                                    if showConfirmButton[self.index!] == true {
                                        Button(action: {
                                            withAnimation {
                                                self.PrizeData.remove(index: self.index!)
                                                self.showConfirmButton[self.index!] = false
                                                self.showRemoveButton[self.index!] = true
                                            }
                                        }) {
                                            ZStack {
                                                Rectangle()
                                                    .foregroundColor(.red)
                                                    .frame(width: 80)
                                                Text(NSLocalizedString("RMT", comment: ""))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }.sheet(isPresented: $showeditingpage) {
                    EditingPage(prizename: self.PrizeData.PrizeList[self.index!].PrizeName, prizequota: String(self.PrizeData.PrizeList[self.index!].PrizeMember), index: self.index)
                        .environmentObject(self.PrizeData)
                }
            }.frame(height: 80)
                .background(Color("CardBG"))
                .cornerRadius(10)
                .padding(.bottom)
                .shadow(color: Color("Shadow"), radius: 10, x: 0, y: 10)
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
        page2_add()
    }
}

struct backButton_p2: View {
    @State var back: Int? = nil
    var body: some View {
        NavigationLink(destination: ContentView_back(), tag: 1, selection: $back) {
            HStack {
                Button(action: {
                    self.back = 1
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                }
                Text(NSLocalizedString("NBT1", comment: ""))
                    .font(.headline)
            }
        }
    }
}
