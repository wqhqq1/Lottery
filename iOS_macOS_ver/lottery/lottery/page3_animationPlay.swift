//
//  page3_animationPlay.swift
//  lottery
//
//  Created by wqhqq on 2020/7/29.
//

import SwiftUI

struct page3_animationPlay: View {
    var PrizeData: [SinglePrize]
    var timer = Timer.publish(every: 3, on: .current, in: .common).autoconnect()
    @State var showResult = false
    @State var size: CGFloat = 1000
    var body: some View {
        VStack(spacing: 10) {
            VStack {
                GIFView(gifName: "video")
                    .onReceive(timer) {_ in
                        withAnimation {
                            self.timer.upstream.connect().cancel()
                            self.showResult = true
                            self.size = 200
                        }
                }
            }.frame(width: self.size, height: self.size)
            if self.showResult {
                page4_result(PrizeData: self.PrizeData)
            }
        }.navigationBarTitle(showResult ? NSLocalizedString("NBLR", comment: ""):NSLocalizedString("ING", comment: ""))
    }
}
