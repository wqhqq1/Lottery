//
//  tabview.swift
//  lottery
//
//  Created by wqhqq on 2020/9/12.
//

import SwiftUI
import pop

var isMac = false

struct tabview: View {
    @State var showSheet: Bool
    @State var showverdSheet = false
    @State var showHider = false
    @State var correct = false
    @State var showUnlocker = true
    @EnvironmentObject var PrizeData: Prizes
    @ObservedObject var lastResult = Prizes(data: dataLoader())
    private let foregroundPublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIApplication.willEnterForegroundNotification
    ).map {_ in}
    private let backgroundPublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIApplication.didEnterBackgroundNotification
    ).map {_ in}
    var body: some View {
        var filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        filePath.appendPathComponent("Lottery Result - \(lastTime).csv")
        try! readyToCopy.write(to: filePath, atomically: true, encoding: .utf8)
        #if targetEnvironment(macCatalyst)
        do {
            isMac = true
        }
        #endif
        return GeometryReader { geo in
            ZStack {
                TabView(){
                    ContentView(showSheet: self.$showverdSheet).frame(width: geo.size.width, height: geo.size.height)
                        .tabItem {
                            Image(systemName:  "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                        .environmentObject(PrizeData)
                    SecureView(passwd: "", hash: pwdHash)
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                            Text("Security") }
                        .tag(1)
                }
                if !showHider {
                    ZStack {
                        visualView(isMac ? .dark:.systemThickMaterialDark)
                        VStack {
                            if isMac {}
                            else {
                                if showUnlocker{
                                    Spacer()
                                }
                            }
                            Text("This app was locked")
                                .fontWeight(.heavy)
                                .foregroundColor(.init(.sRGB, white: 1, opacity: 0.5))
                                .font(.title)
                                .padding()
                            Button(action: {
                                self.showUnlocker = true
                            }) {
                                ZStack {
                                    visualView(.light)
                                        .frame(width: 150, height: 70)
                                        .cornerRadius(50)
                                    Text(self.correct ? "Verifying...":"Unlock the App")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.init(.sRGB, white: 1, opacity: 0.5))
                                }
                            }.padding(.top, 20)
                        }.padding(.bottom, self.showUnlocker ? 50:0)
                        unlockAnimationsMainController(self.$correct, isComplete: self.$showHider, loadSheet: self.$showSheet, showSheet: self.$showverdSheet).frame(width: geo.size.width, height: 80).offset(x: isMac ? 0 - geo.size.width * 0.45:0, y: isMac ? 0 - geo.size.height - 30:0 - geo.size.height + 50)
                    }
                    .ignoresSafeArea()
                    .background(AlertControl(show: self.$showUnlocker, correct: self.$correct, title: "Locked", message: "This app was locked, Please enter the correct password to unlock it."))
                    .transition(.offset(x: 0, y: 0 - geo.size.height))
                }
            }.onReceive(self.foregroundPublisher) {
                self.showHider = false
            }
            .onReceive(self.backgroundPublisher) {
                self.showUnlocker = true
            }
        }
    }
}

struct tabview_Previews: PreviewProvider {
    static var previews: some View {
        tabview(showSheet: false)
    }
}
