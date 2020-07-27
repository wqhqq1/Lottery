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
    @State var showRemoveButton = false
    @State var selected: [Int] = []
    var size: CGFloat = 65.0
    
    var body: some View {
        HStack {
            Spacer()
            if showRemoveButton {
                Button(action : {
                    withAnimation {
                        PrizeData.removeMore(index: selected)
                    }
                    selected.removeAll()
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.black)
                        .imageScale(.large)
                        .padding(.trailing)
                }
            }
            Button(action: {
                showRemoveButton.toggle()
                selected.removeAll()
            }){
                Text(showRemoveButton ? NSLocalizedString("EXT", comment: "Done"):NSLocalizedString("EDIT", comment: ""))
                    .font(.custom("", size: 20))
                    .fontWeight(.heavy)
                    .padding(.trailing)
            }
        }
        ZStack {
            ScrollView{
                ForEach(PrizeData.PrizeList) {prize in
                    if !prize.isRemoved {
                        HStack {
                            if showRemoveButton {
                                Button(action: {
                                    
                                    withAnimation {
                                        PrizeData.remove(index: prize.id)
                                    }
                                }){
                                    Image(systemName: "trash.fill")
                                        .resizable()
                                        .frame(width: 25, height: 30)
                                        .foregroundColor(.black)
                                        .padding(.trailing)
                                }
                                .padding([.leading, .bottom])
                            }
                            SingleCard(showRemoveButton: $showRemoveButton, selected: $selected, index: prize.id)
                                .environmentObject(PrizeData)
                                .animation(.spring())
                                .transition(.slide)
                        }.animation(.spring())
                        .transition(.slide)
                    }
                }.animation(.spring())
                .transition(.slide)
//                    .transition(.slide)
            }.padding(.horizontal)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    HStack {
                        NavigationLink(destination: page3_result(PrizeData: PrizeData.PrizeList_cacu), tag: 1, selection: $selection) {
                            Button(action: {
                                AllPrizesMember = APM_ccltor(data: PrizeData.PrizeList_cacu)
                                rands = Random(start: 1, end: AllPrizesMember + 1, Members: MemberNumber)
                                var i = 0, j = 0
                                while i < PrizeData.PrizeList_cacu.count {
                                    while j < PrizeData.PrizeList_cacu[i].PrizeM {
                                        PrizeData.PrizeList_cacu[i].Lottery_result += "\n" + MemberNames[rands[j] - 1] + " "
                                        j += 1
                                    }
                                    i += 1
                                }
                                selection = 1
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
                                .environmentObject(PrizeData)
                        }
                    }
                }
            }
        }.navigationBarTitle(NSLocalizedString("ADDT", comment: ""))
    }
}

struct SingleCard: View {
    @State var showeditingpage = false
    @EnvironmentObject var PrizeData: Prizes
    @Binding var showRemoveButton: Bool
    @Binding var selected: [Int]
    @State var isSelected = false
    var index: Int?
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 6)
                .foregroundColor(.blue)
            Button(action: {
                showeditingpage = true
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
                        if showRemoveButton{
                            Button(action: {
                                selected.append(index!)
                            }) {
                                Image(systemName: self.selected.firstIndex(where: {$0 == self.index}) != nil ? "checkmark.circle.fill":"circle")
                                    .imageScale(.large)
                                    .foregroundColor(.black)
                                    .padding(.trailing)
                            }
                        }
                    }
                }
            }.sheet(isPresented: $showeditingpage) {
                EditingPage(prizename: PrizeData.PrizeList[index!].PrizeName, prizequota: String(PrizeData.PrizeList[index!].PrizeMember), index: self.index)
                    .environmentObject(PrizeData)
            }
        }.frame(height: 80)
        .background(Color("CardBG"))
        .cornerRadius(10)
        .padding(.bottom)
        .shadow(color: Color("Shadow"), radius: 10, x: 0, y: 10)
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
