//
//  SwiftUIRepresentable.swift
//  FaceIDUnlockAnimation
//
//  Created by wqhqq on 10/4/20.
//

import SwiftUI
import pop

struct unlockAnimationsMainController: UIViewControllerRepresentable {
    
    let Size: CGRect
    let duration: CFTimeInterval
    let lockColor: UIColor
    @Binding var isComplete: Bool
    @Binding var unlockNow: Bool
    @Binding var loadSheet: Bool
    @Binding var showSheet: Bool
    
    //How To Use
    //unlockNow: when it become True value, the lock will be unlocked
    //duration: how long the unlock animation animate
    //frame: size of the lock
    //isComplete: change to True when animation completed
    //loadSheet: will load a thing which will be presented after animation completed if this value is True **This value will reset to False after load once
    //showSheet: will change to True when loadSheet enabled
    
    init(_ unlockNow: Binding<Bool>, duration: CFTimeInterval = 1, frame: CGRect = CGRect(x: 0, y: 0, width: 35, height: 51), lockColor: UIColor = .white, isComplete: Binding<Bool> = .constant(false), loadSheet: Binding<Bool> = .constant(false), showSheet: Binding<Bool> = .constant(false)) {
        self._unlockNow = unlockNow
        self.Size = frame
        self.duration = duration
        self._isComplete = isComplete
        self._loadSheet = loadSheet
        self._showSheet = showSheet
        self.lockColor = lockColor
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        let controller = ViewController(updateNow: self.$unlockNow, frame: self.Size, lockColor: self.lockColor, isComplete: self.$isComplete, correct: self.$unlockNow, loadSheet: self.$loadSheet, showSheet: self.$showSheet)
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

