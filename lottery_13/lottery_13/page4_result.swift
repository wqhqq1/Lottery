//
//  page4_result.swift
//  lottery_13
//
//  Created by wqhqq on 2020/7/20.
//

import SwiftUI

struct page4_result: View {
    var body: some View {
        List(Prizes) { prize in
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

struct page4_result_Previews: PreviewProvider {
    static var previews: some View {
        page4_result()
    }
}
