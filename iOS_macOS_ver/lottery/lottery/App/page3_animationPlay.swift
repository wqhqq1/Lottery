//
//  page3_animationPlay.swift
//  lottery
//
//  Created by wqhqq on 2020/7/29.
//

import SwiftUI
import WidgetKit


struct page3_animationPlay: View {
    @EnvironmentObject var PrizeData: Prizes
    var timer = Timer.publish(every: 3, on: .current, in: .common).autoconnect()
    @State var showResult: Int? = nil
    @State var size: CGFloat = 1000
    @Binding var filepath: URL
    var body: some View {
        NavigationLink(destination: result(filepath: self.$filepath).environmentObject(PrizeData), tag: 1, selection: $showResult) {
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
    @State var showSavedAlert = false
    @State var filePathInput = ""
    @Binding var filepath: URL
    @Environment(\.presentationMode) var presentation
    var body: some View {
        WidgetCenter.shared.reloadAllTimelines()
        return GeometryReader { geo in
            ZStack {
                BlurView().frame(width: geo.size.width, height: geo.size.height)
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        ForEach(self.PrizeData.PrizeList_cacu) { prize in
                            SingleResult(index: prize.id)
                                .environmentObject(self.PrizeData)
                                .frame(height: 80)
                                .animation(.spring())
                        }.animation(.spring())
                    }.padding(.horizontal)
                    .animation(.spring())
                }.navigationBarTitle(sheetModeResult ? lastTime:NSLocalizedString("NBLR", comment: ""))
                    .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton_p3().environmentObject(PrizeData))
                VStack {
                    Spacer()
                    Button(action: {
                        if isMac {
                            var path = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
                            path.appendPathComponent("Lottery Result - \(lastTime) +\(arc4random()).csv")
                            try? readyToCopy.write(to: path, atomically: true, encoding: .utf8)
                            self.showSavedAlert = true
                        }
                        else {
                            self.showAlert = true
                        }
                    }) {
                        HStack {
                            Text(NSLocalizedString("CPR", comment: ""))
                                .foregroundColor(.white)
                            Image(systemName: "square.and.arrow.down.fill")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                    }.sheet(isPresented: self.$showAlert) {
                        ShareSheet([filepath])
                    }
                    .padding(.bottom)
                    .shadow(color: Color("Shadow"), radius: 10)
                    if sheetModeResult {
                        Button(action: {
                            sheetModeResult = false
                            self.presentation.wrappedValue.dismiss()
                        }) {
                            Text(NSLocalizedString("DONE", comment: ""))
                                .foregroundColor(.white)
                        }.padding()
                    }
                }
                CustomMessageBox("Successfully Saved!", show: self.$showSavedAlert)
            }.padding().frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct backButton_p3: View {
    @State var back: Int? = nil
    @EnvironmentObject var PrizeData: Prizes
    var body: some View {
        NavigationLink(destination: page2_add(PrizeData: Prizes(data: self.PrizeData.PrizeList_cacu)).transition(.move(edge: .trailing)), tag: 1, selection: $back) {
            HStack {
                Button(action: {
                    self.back = 1
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
                Text(NSLocalizedString("ADDT", comment: ""))
                    .font(Font.system(size: 22))
                    .foregroundColor(.white)
            }.transition(.move(edge: .trailing))
        }.transition(.slide)
    }
}
