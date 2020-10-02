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
                    ContentView(showSheet: self.showSheet).frame(width: geo.size.width, height: geo.size.height)
                        .sheet(isPresented: self.$showverdSheet) {
                            resultReplay(filePath: .constant(filePath))
                        }
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
                        visualView(.dark)
                        Text("The contents here was locked, please enter the correct password to unlock this app.")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                        VStack{
                            Spacer()
                            Button(action: {
                                self.showUnlocker = true
                            }) {
                                ZStack {
                                    visualView(.light)
                                        .frame(width: 100, height: 50)
                                        .cornerRadius(50)
                                    Text("Unlock App")
                                        .foregroundColor(.white)
                                }
                            }
                        }.padding(.all, 20)
                    }
                    .ignoresSafeArea()
                    .background(AlertControl(show: self.$showUnlocker, correct: self.$showHider, title: "Locked", message: "This app was locked, Please enter the correct password to unlock it."))
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
