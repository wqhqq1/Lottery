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
    @State var isEditingMode = false
    @State var showAlert = false
    @State var selected: [Int] = []
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
                            .foregroundColor(.black)
                            .imageScale(.large)
                            .padding(.trailing)
                    }
                    .actionSheet(isPresented: self.$showAlert) {
                        ActionSheet(title: Text(NSLocalizedString("RMT", comment: "")), message: Text(NSLocalizedString("CRMT", comment: "")),
                                    buttons: [.default(Text(NSLocalizedString("RMT", comment: ""))) {
                                        self.PrizeData.removeMore(index: self.selected)
                                        self.selected = []
                                        }])
                    }
                }
                Button(action: {
                    var i = 0
                    while i < self.showRemoveButton.count {
                        self.showRemoveButton[i].toggle()
                        i += 1
                    }
                    self.isEditingMode.toggle()
                    self.selected.removeAll()
                }){
                    Text(isEditingMode ? NSLocalizedString("EXT", comment: "Done"):NSLocalizedString("EDIT", comment: ""))
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
                                    SingleCard(showRemoveButton: self.$showRemoveButton, selected: self.$selected, index: prize.id)
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
                        HStack {
                            NavigationLink(destination: page3_result(PrizeData: PrizeData.PrizeList_cacu), tag: 1, selection: $selection) {
                                Button(action: {
                                    AllPrizesMember = APM_ccltor(data: self.PrizeData.PrizeList_cacu)
                                    rands = Random(start: 1, end: AllPrizesMember + 1, Members: MemberNumber)
                                    var i = 0, j = 0
                                    while i < self.PrizeData.PrizeList_cacu.count {
                                        while j < self.PrizeData.PrizeList_cacu[i].PrizeM {
                                            self.PrizeData.PrizeList_cacu[i].Lottery_result += "\n" + MemberNames[rands[j] - 1] + " "
                                            j += 1
                                        }
                                        i += 1
                                    }
                                    self.selection = 1
                                })
                                {
                                    btnAdd()
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
                        }
                    }
                }
            }.navigationBarTitle(NSLocalizedString("ADDT", comment: ""))
        }
    }
}

struct SingleCard: View {
    @State var showeditingpage = false
    @EnvironmentObject var PrizeData: Prizes
    @Binding var showRemoveButton: [Bool]
    @Binding var selected: [Int]
    @State var isSelected = false
    @State var showConfirmButton = false
//    @State var showAlert = false
    var index: Int?
    var body: some View {
        HStack {
            if self.showRemoveButton[index!] {
                Button(action: {
                    self.showConfirmButton = true
                    self.showRemoveButton[self.index!] = false
                }){
                    Image(systemName: "minus.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.red)
                        .padding(.trailing)
                }
                .padding([.leading, .bottom])
            }
            HStack {
                Rectangle()
                    .frame(width: 6)
                    .foregroundColor(.blue)
                Button(action: {
                    if self.showConfirmButton == true {
                        self.showConfirmButton = false
                        self.showRemoveButton[self.index!] = true
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
                                if showConfirmButton == true {
                                    Button(action: {
                                        withAnimation {
                                            self.PrizeData.remove(index: self.index!)
                                            self.showConfirmButton = false
                                            self.showRemoveButton[self.index!] = true
                                        }
                                    }) {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.red)
                                                .frame(width: 80)
                                            Text(NSLocalizedString("RMT", comment: ""))
                                                .foregroundColor(.black)
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
