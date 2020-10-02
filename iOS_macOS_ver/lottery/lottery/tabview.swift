//
//  tabview.swift
//  lottery
//
//  Created by wqhqq on 2020/9/12.
//

import SwiftUI

var isMac = false

struct tabview: View {
    @State var showSheet: Bool
    @State var showverdSheet = false
    @State var showHider = false
    @State var showUnlocker = true
    @EnvironmentObject var PrizeData: Prizes
    @ObservedObject var lastResult = Prizes(data: dataLoader())
    private let hidePublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIApplication.willEnterForegroundNotification
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
                                    Text("Unlock the App")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.init(.sRGB, white: 1, opacity: 0.5))
                                }
                            }.padding(.top, 20)
                        }.padding(.bottom, self.showUnlocker ? 50:0)
                        VStack {
                            Image(systemName: "lock.fill")
                                .imageScale(.large)
                                .foregroundColor(.white)
                            Spacer()
                        }.padding(.top, 50)
                    }
                    .ignoresSafeArea()
                    .background(AlertControl(show: self.$showUnlocker, correct: self.$showHider, title: "Locked", message: "This app was locked, Please enter the correct password to unlock it.", loadSheet: self.$showSheet, showSheet: self.$showverdSheet))
                    .transition(.offset(x: 0, y: 0 - geo.size.height))
                }
            }.onReceive(self.hidePublisher) {
                self.showHider = false
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
