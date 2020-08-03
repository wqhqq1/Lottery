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
        Button(action: {
            self.showResultPage = true
        }) {
            HStack {
                Rectangle()
                    .frame(width: 6)
                    .foregroundColor(.blue)
                VStack(alignment: .leading, spacing: 6.0) {
                    Text(self.PrizeList.PrizeList_cacu[self.index].PrizeName)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("arrow"))
                    .padding()
            }.background(Color("CardBG"))
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
        NavigationView {
            VStack {
                Form {
                    Section {
                            Text("\(NSLocalizedString("CT", comment: ""))\(result)\(NSLocalizedString("GT", comment: ""))\(self.prize)")
                                .font(.title)
                    }
                    Section {
                        Button(action: {
                            self.presentation.wrappedValue.dismiss()
                        }) {
                            Text(NSLocalizedString("EXT", comment: "Done"))
                        }
                    }
                }
            }.navigationBarTitle(self.prize)
        }
    }
}
