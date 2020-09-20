//
//  page3_result.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import SwiftUI

struct SingleResult: View {
    @State var showResultPage = false
    @EnvironmentObject var PrizeList: Prizes
    var index: Int
    var body: some View {
        var range = ""
        if self.PrizeList.PrizeList_cacu[index].enabledCmds && self.PrizeList.PrizeList_cacu[index].maxCmd != nil && self.PrizeList.PrizeList_cacu[index].minCmd != nil {
            if self.PrizeList.PrizeList_cacu[index].minCmd == self.PrizeList.PrizeList_cacu[index].maxCmd {
                range = "(=" + String(self.PrizeList.PrizeList_cacu[index].minCmd!) + ")"
            }
            else {
                range = "(" + String(self.PrizeList.PrizeList_cacu[index].minCmd!) + "≤,≤" + String(self.PrizeList.PrizeList_cacu[index].maxCmd!) + ")"
            }
        }
        return Button(action: {
            self.showResultPage = true
        }) {
            HStack {
                Rectangle()
                    .frame(width: 6)
                    .foregroundColor(.white)
                VStack(alignment: .leading, spacing: 6.0) {
                    HStack {
                        Text(self.PrizeList.PrizeList_cacu[self.index].PrizeName)
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        Text(range)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("arrow"))
                    .padding()
            }.background(Color(.sRGB, white: 1, opacity: 0.2))
                .cornerRadius(10)
                .padding(.bottom)
                .shadow(color: Color("Shadow"), radius: 10, x: 0, y: 10)
        }.sheet(isPresented: $showResultPage) {
            resultPage(prize: self.PrizeList.PrizeList_cacu[self.index].PrizeName, result: self.PrizeList.PrizeList_cacu[self.index].Lottery_result)
        }}
}

struct resultPage: View {
    var prize: String
    var result: String
    @Environment(\.presentationMode) var presentation
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    BlurView().frame(width: geo.size.width, height: geo.size.height)
                    VStack(alignment: .leading) {
                        Text(self.prize)
                            .font(Font.custom("", size: 40)).foregroundColor(.init(white: 1, opacity: 0.8)).padding(.leading, 30)
                        Form {
                            Section {
                                Text("\(NSLocalizedString("CT", comment: ""))\(result)\(NSLocalizedString("GT", comment: ""))\(self.prize)")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                            Section {
                                Button(action: {
                                    self.presentation.wrappedValue.dismiss()
                                }) {
                                    Text(NSLocalizedString("EXT", comment: "Done"))
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
