//
//  page3_animationPlay.swift
//  lottery
//
//  Created by wqhqq on 2020/7/29.
//

import SwiftUI

struct page3_animationPlay: View {
    @EnvironmentObject var PrizeData: Prizes
    var timer = Timer.publish(every: 3, on: .current, in: .common).autoconnect()
    @State var showResult: Int? = nil
    @State var size: CGFloat = 1000
    var body: some View {
        NavigationLink(destination: result().environmentObject(PrizeData), tag: 1, selection: $showResult) {
            GIFView(gifName: "video")
                .onReceive(self.timer) {_ in
                    withAnimation {
                        self.showResult = 1
                        self.timer.upstream.connect().cancel()
                    }
            }
        }
        .navigationBarTitle(NSLocalizedString("ING", comment: ""))
        .navigationBarBackButtonHidden(true)
    }
}

struct result: View {
    @EnvironmentObject var PrizeData: Prizes
    @State var showAlert = false
    @State var filePathInput = ""
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ForEach(self.PrizeData.PrizeList_cacu) { prize in
                    SingleResult(index: prize.id)
                        .environmentObject(self.PrizeData)
                        .frame(height: 80)
                        .animation(.spring())
                }.animation(.spring())
                Spacer()
                Button(action: {
                    self.showAlert = true
                }) {
                    HStack {
                        Text(NSLocalizedString("CPR", comment: ""))
                        Image(systemName: "square.and.arrow.down.fill")
                            .imageScale(.large)
                    }
                }.background(AlertControl(show: self.$showAlert, title: "Save", message: "Input file name."))
            }.padding(.horizontal)
                .animation(.spring())
        }.navigationBarTitle(NSLocalizedString("NBLR", comment: ""))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton_p3().environmentObject(PrizeData))
    }
}

struct backButton_p3: View {
    @State var back: Int? = nil
    @EnvironmentObject var PrizeData: Prizes
    var body: some View {
        NavigationLink(destination: page2_add(PrizeData: PrizeData).transition(.move(edge: .trailing)), tag: 1, selection: $back) {
            HStack {
                Button(action: {
                    self.back = 1
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                }
                Text(NSLocalizedString("ADDT", comment: ""))
                    .font(Font.system(size: 22))
            }.transition(.move(edge: .trailing))
        }.transition(.slide)
    }
}
