//
//  fored and modifired from https://github.com/warpling/LockAnimationTest
//  LockAnimationTest
//
//  Created by Ryan McLeod on 12/17/18.
//  Copyright © 2018 Grow Pixel. All rights reserved.
//

import SwiftUI
import pop

struct unlockAnimationsMainController: UIViewControllerRepresentable {
    
    let Size: CGRect
    let duration: CFTimeInterval
    @Binding var isComplete: Bool
    @Binding var unlockNow: Bool
    @Binding var loadSheet: Bool
    @Binding var showSheet: Bool
    
    init(_ unlockNow: Binding<Bool>, duration: CFTimeInterval = 1, frame: CGRect = CGRect(x: 0, y: 0, width: 35, height: 51), isComplete: Binding<Bool> = .constant(false), loadSheet: Binding<Bool> = .constant(false), showSheet: Binding<Bool> = .constant(false)) {
        self._unlockNow = unlockNow
        self.Size = frame
        self.duration = duration
        self._isComplete = isComplete
        self._loadSheet = loadSheet
        self._showSheet = showSheet
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        let controller = ViewController(updateNow: self.$unlockNow, frame: self.Size, isComplete: self.$isComplete, correct: self.$unlockNow, loadSheet: self.$loadSheet, showSheet: self.$showSheet)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Run a fixed animation to (un)lock depending on current progress
        if self.unlockNow {
            let lockAnimation = POPBasicAnimation()
            lockAnimation.property = uiViewController.lockView.animator.animatableProperty()
            lockAnimation.fromValue = 0.0
            lockAnimation.toValue = 2.0
            lockAnimation.duration = self.duration * 2.0
            lockAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            uiViewController.lockView.animator.pop_add(lockAnimation, forKey: "lock")
        }
        if !self.unlockNow {
            let lockAnimation = POPBasicAnimation()
            lockAnimation.property = uiViewController.lockView.animator.animatableProperty()
            lockAnimation.fromValue = 2.0
            lockAnimation.toValue = 0.0
            lockAnimation.duration = 0.0
            lockAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            uiViewController.lockView.animator.pop_add(lockAnimation, forKey: "lock")
        }
        return
    }
}

class ViewController: UIViewController {
    
    @Binding var updateNow: Bool
    var lockView: LockView
    
    
    init(updateNow: Binding<Bool>, frame: CGRect = CGRect(x: 0, y: 0, width: 35, height: 51), isComplete: Binding<Bool>, correct: Binding<Bool>, loadSheet: Binding<Bool>, showSheet: Binding<Bool>) {
        self._updateNow = updateNow
        self.lockView = LockView(frame: frame, isComplete: isComplete, correct: correct, loadSheet: loadSheet, showSheet: showSheet)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear

        lockView.clipsToBounds = false
        lockView.center = view.center

        view.addSubview(lockView)
    }
}


struct testUnlockAnimations: View {
    @State var toggleStatus: Bool = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .ignoresSafeArea()
                    .frame(width: geo.size.width, height: geo.size.height)
                VStack {
                    unlockAnimationsMainController(self.$toggleStatus, duration: 1)
                        .frame(width: geo.size.width, height: 80).offset(x: 0, y: 0 - geo.size.height / 2)
                    Spacer()
                    Button(action: {
                        self.toggleStatus = true
                    }) {
                        Text("Toggle Status")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct preview: PreviewProvider {
    static var previews: some View {
        testUnlockAnimations()
    }
}
