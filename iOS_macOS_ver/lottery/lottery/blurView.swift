//
//  blurView.swift
//  lottery
//
//  Created by wqhqq on 2020/9/13.
//

import SwiftUI

struct blurview<Content: View>: UIViewControllerRepresentable {
    func updateUIViewController(_ uiView: UIViewController, context: Context) {
        return
    }
    
    let content: Content
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let host = UIHostingController(rootView: content)
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        host.view.addSubview(blurView)
        return host
    }
}

struct testingBlurView: View {
    var body: some View {
        ContentView(showSheet: false).background(Color.clear)
    }
}

struct blurView_Previews: PreviewProvider {
    static var previews: some View {
        testingBlurView()
    }
}
