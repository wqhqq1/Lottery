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
                        Image(systemName: "doc.on.clipboard")
                    }
                }
                .textFieldAlert(isShowing: self.$showAlert, title: "Input file path")
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
        NavigationLink(destination: page2_add(PrizeData: PrizeData), tag: 1, selection: $back) {
            HStack {
                Button(action: {
                    self.back = 1
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                }
                Text(NSLocalizedString("ADDT", comment: ""))
                    .font(.headline)
            }
        }.transition(.slide)
    }
}

struct TextFieldAlert<Presenting>: View where Presenting: View {
    
    @Binding var isShowing: Bool
    @State var text: String = ""
    let presenting: Presenting
    let title: String
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(self.isShowing)
                VStack {
                    Text(self.title)
                    TextField("File name.", text: self.$text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Divider()
                    HStack {
                        Button(action: {
                            if self.text != "" {
                                var path = ""
                                if #available(iOS 13.0, *) {
                                    path = NSHomeDirectory() + "/Documents/\(self.text).csv"
                                }
                                if #available(OSX 10.15, *) {
                                    path = "/Users/Shared/\(self.text).csv"
                                }
                                try! readyToCopy.write(toFile: path, atomically: true, encoding: .utf8)
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("OK")
                                .foregroundColor(.black)
                        }
                        Divider()
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Cancel")
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding()
                .background(Color("CardBG"))
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                    .shadow(radius: 3)
                    .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
    
}

extension View {
    
    func textFieldAlert(isShowing: Binding<Bool>, title: String) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       presenting: self,
                       title: title)
    }
    
}
