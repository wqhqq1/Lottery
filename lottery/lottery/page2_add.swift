//
//  ContentView.swift
//  lottery
//
//  Created by wqhqq on 2020/7/25.
//

import SwiftUI

var AllPrizesMember: Int = 0, rands = [Int]()

struct page2_add: View {
    
    @ObservedObject var PrizeData = Prizes(data: [SinglePrize(PrizeName: "一等奖", PrizeMember: 1)])
    @State var selection: Int? = nil
    @State var showeditingpage = false
    var size: CGFloat = 65.0
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView{
                ForEach(PrizeData.PrizeList) {prize in
                    SingleCard(index: prize.id)
                            .environmentObject(PrizeData)
                    }
                }.padding(.horizontal)
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    HStack {
                        NavigationLink(destination: page3_result(PrizeData: PrizeData.PrizeList), tag: 1, selection: $selection) {
                            Button(action: {
                                AllPrizesMember = APM_ccltor(data: PrizeData.PrizeList)
                                rands = Random(start: 1, end: AllPrizesMember + 1, Members: MemberNumber)
                                var i = 0, j = 0
                                while i < PrizeData.PrizeList.count {                        while j < PrizeData.PrizeList[i].PrizeM {
                                    PrizeData.PrizeList[i].Lottery_result += "\n" + MemberNames[rands[j] - 1] + " "
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
                                .shadow(radius: 10)
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
            
                VStack(alignment: .leading, spacing: 6.0) {
                    Text(PrizeData.PrizeList[index!].PrizeName)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    Text("名额：\(PrizeData.PrizeList[index!].PrizeMember)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                }
            }.sheet(isPresented: $showeditingpage) {
                EditingPage(prizename: PrizeData.PrizeList[index!].PrizeName, prizequota: String(PrizeData.PrizeList[index!].PrizeMember), index: self.index)
                    .environmentObject(PrizeData)
            }
        }.frame(height: 80)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.bottom)
        .shadow(radius: 10, x: 0, y: 10)
    }
}

struct btnAdd: View {
    var size: CGFloat = 65.0
    var body: some View {
        ZStack{
            Group {
                Circle()
                    .fill(Color.red)
                    .shadow(radius: 10)
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
