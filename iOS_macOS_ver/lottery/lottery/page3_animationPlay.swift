//
//  page3_animationPlay.swift
//  lottery
//
//  Created by wqhqq on 2020/7/29.
//

import SwiftUI

struct page3_animationPlay: View {
    var PrizeData: [SinglePrize]
    var timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @State var showResult = false
    var body: some View {
        VStack {
            if showResult == false {
                GIFView(gifName: "video")
                    .onReceive(timer) {_ in
                        withAnimation {
                            self.timer.upstream.connect().cancel()
                            self.showResult = true
                        }
                }
            }
            else {
                page4_result(PrizeData: self.PrizeData)
            }
        }
    }
}
