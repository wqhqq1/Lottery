//
//  tabview.swift
//  lottery
//
//  Created by wqhqq on 2020/9/12.
//

import SwiftUI

struct tabview: View {
    var colorList: [[Color]] = [[.orange, .purple],
                                [.purple, .orange],
                                [.purple, .orange, .purple]]
    @State var show0 = false
    @State var show1 = false
    @State var show2 = false
    @State var index = 0
    var timer = Timer.TimerPublisher(interval: 10.1, runLoop: .main, mode: .default).autoconnect()
    var body: some View {
        GeometryReader { geo in
            TabView() {
                ZStack {
                    if show1 {
                        LinearGradient(gradient: Gradient(colors: self.colorList[0]), startPoint: UnitPoint(x: 0, y: 0), endPoint: .bottom)
                            .ignoresSafeArea()
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 10)))
                    }
                    ContentView(showSheet: false)
                        .onReceive(self.timer) {_ in
                            switch self.index % 2 {
                            case 0: self.show1 = false
                            case 1: self.show1 = true
                            default: do {
                                
                            }
                            }
                            
                            index += 1
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                }.transition(.opacity)
                .background(LinearGradient(gradient: Gradient(colors: self.colorList[1]), startPoint: UnitPoint(x: 0, y: 0), endPoint: .bottom)
                                .ignoresSafeArea().frame(width: geo.size.width, height: geo.size.height))
            .tabItem {
                Image(systemName:  "house.fill")
                Text("Home")
            }
            .tag(0)
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
        tabview()
    }
}
