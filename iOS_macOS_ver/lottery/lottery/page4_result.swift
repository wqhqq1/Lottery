//
//  page3_result.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import SwiftUI

struct page4_result: View {
    var PrizeData: [SinglePrize]
    var body: some View {
        VStack {
            List(PrizeData) { prize in
                NavigationLink(destination: ScrollView {Text("\(NSLocalizedString("CT", comment: ""))\(prize.Lottery_result)\(NSLocalizedString("GT", comment: ""))\(prize.PrizeName)")}.navigationBarTitle(prize.PrizeName).font(.title)) {
                    Text(prize.PrizeName)
                        .font(.title)
                }
            }
        }
    }
}
