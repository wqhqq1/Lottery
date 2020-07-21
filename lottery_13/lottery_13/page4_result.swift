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
            NavigationLink(destination: Text("恭喜：\(prize.Lottery_result)获得\(prize.PrizeName)").navigationBarTitle(prize.PrizeName).font(.title)) {
                Text(prize.PrizeName)
                    .font(.title)
            }
        }.navigationBarTitle("抽奖结果")
        Button(action: {
            abort()
        },
               label: {
                Text("再抽一次")
               })
    }
}

struct page4_result_Previews: PreviewProvider {
    static var previews: some View {
        page4_result()
    }
}
