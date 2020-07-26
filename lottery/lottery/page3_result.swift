//
//  page3_result.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import SwiftUI

struct page3_result: View {
    var PrizeData: [SinglePrize]
    var body: some View {
        List(PrizeData) { prize in
            NavigationLink(destination: ScrollView {Text("\(NSLocalizedString("CT", comment: ""))\(prize.Lottery_result)\(NSLocalizedString("GT", comment: ""))\(prize.PrizeName)")}.navigationBarTitle(prize.PrizeName).font(.title)) {
                Text(prize.PrizeName)
                    .font(.title)
            }
        }.navigationBarTitle(NSLocalizedString("NBLR", comment: ""))
        Button(action: {
            abort()
        },
               label: {
                Text(NSLocalizedString("EXT", comment: ""))
               })
    }
}
