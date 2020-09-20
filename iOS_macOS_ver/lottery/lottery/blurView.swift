//
//  blurView.swift
//  lottery
//
//  Created by wqhqq on 2020/9/13.
//

import SwiftUI

//struct uiBlur<Content: View>: UIViewControllerRepresentable {
//    let content: Content
//    init(_ content: () -> Content) {
//        self.content = content()
//    }
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let blurEffect = UIBlurEffect(style: .systemChromeMaterialLight)
//        let visualView = UIVisualEffectView(effect: blurEffect)
//        let host = UIHostingController(rootView: self.content)
//        visualView.frame.size = CGSize(width: host.view.frame.width, height: host.view.frame.height)
//        host.view.addSubview(visualView)
//        return host
//
//    }
//    func updateUIViewController(_ uiView: UIViewController, context: Context) {
//        return
//    }
//}

struct BlurView: View {
    var colorList: [[Color]] = [[.orange, .purple],
                                [.purple, .orange],
                                [.purple, .orange, .purple]]
    @State var show = false
    var timer = Timer.TimerPublisher(interval: 20.1, runLoop: .current, mode: .default).autoconnect()
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

struct blurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView()
    }
}
