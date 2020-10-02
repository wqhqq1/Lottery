//
//  blurView.swift
//  lottery
//
//  Created by wqhqq on 2020/9/13.
//

import SwiftUI

struct BlurView: View {
    var colorList: [[Color]] = [[.orange, .purple],
                                [.purple, .orange],
                                [.purple, .orange, .purple]]
    @State var show = false
    var timer = Timer.TimerPublisher(interval: 20.1, runLoop: .current, mode: .default)
    @State var index = 0
    var body: some View {
        GeometryReader{ geo in
            ZStack {
                if show {
                    LinearGradient(gradient: Gradient(colors: self.colorList[0]), startPoint: UnitPoint(x: 0, y: 0), endPoint: .bottom)
                        .ignoresSafeArea()
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 20)))
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                Rectangle()
                    .opacity(0)
                    .onReceive(timer) {_ in
                        self.show.toggle()
                        index += 1
                        print("Received!\nindex: \(index)")
                    }
                
            }
            .background(LinearGradient(gradient: Gradient(colors: self.colorList[1]), startPoint: UnitPoint(x: 0, y: 0), endPoint: .bottom)
                            .ignoresSafeArea()
                            .frame(width: geo.size.width, height: geo.size.height))
        }
    }
}

struct visualView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    init(_ style: UIBlurEffect.Style) {
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIView {
        let effectView = UIBlurEffect(style: self.style)
        let visualView = UIVisualEffectView(effect: effectView)
        return visualView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        return
    }
}

struct blurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView()
    }
}
