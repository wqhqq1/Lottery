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
    @EnvironmentObject var PrizeData: Prizes
    @ObservedObject var lastResult = Prizes(data: dataLoader())
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
            TabView() {
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
            .background(AlertControl(show: self.$showSheet, correct: self.$showverdSheet, title: "Locked", message: "Content here was locked, input the password you set to unlock the contents."))
        }
    }
}

struct tabview_Previews: PreviewProvider {
    static var previews: some View {
        tabview(showSheet: false)
    }
}
