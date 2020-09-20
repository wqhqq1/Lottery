//
//  tabview.swift
//  lottery
//
//  Created by wqhqq on 2020/9/12.
//

import SwiftUI

struct tabview: View {
    @State var showSheet: Bool
    @EnvironmentObject var PrizeData: Prizes
    @ObservedObject var lastResult = Prizes(data: dataLoader())
    var body: some View {
        var filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        filePath.appendPathComponent("Lottery Result - \(lastTime).csv")
        try! readyToCopy.write(to: filePath, atomically: true, encoding: .utf8)
        return GeometryReader { geo in
            TabView() {
                ContentView(showSheet: self.showSheet).frame(width: geo.size.width, height: geo.size.height)
                    .sheet(isPresented: self.$showSheet) {
                        resultReplay(filePath: .constant(filePath))
                    }
                    .tabItem {
                        Image(systemName:  "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                    .environmentObject(PrizeData)
                Text("bcd")
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Security") }
                    .tag(1)
            }
        }
    }
}

struct tabview_Previews: PreviewProvider {
    static var previews: some View {
        tabview(showSheet: false)
    }
}
