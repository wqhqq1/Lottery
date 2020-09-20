//
//  keyboardfix.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import SwiftUI

struct KeyboardHost_offset20<Content: View>: View {
    let view: Content
    
    @State private var keyboardHeight: CGFloat = 0
    var showLastRButton: Binding<Bool>
    var showDoneButton: Binding<Bool>
    
    private let showPublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardDidChangeFrameNotification
    ).map { (notification) -> CGFloat in
        if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            return rect.size.height
        } else {
            return 0
        }
    }
    
    private let hidePublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardWillHideNotification
    ).map {_ -> CGFloat in 0}
    
    // Like HStack or VStack, the only parameter is the view that this view should layout.
    // (It takes one view rather than the multiple views that Stacks can take)
    init(showDoneButton: Binding<Bool>, showButton: Binding<Bool>, @ViewBuilder content: () -> Content) {
        view = content()
        self.showLastRButton = showButton
        self.showDoneButton = showDoneButton
    }
    
    var body: some View {
        VStack {
            view
                .transition(.slide)
                .animation(.easeInOut)
                .offset(x: 0, y: 0 - keyboardHeight)
        }.onReceive(showPublisher.merge(with: hidePublisher)) { (height) in
            self.keyboardHeight = height * 0.02
            if self.keyboardHeight == 0.0 {
                self.showLastRButton.wrappedValue = true
                self.showDoneButton.wrappedValue = false
            }
        }
    }
}

struct KeyboardHost_edit<Content: View>: View {
    let view: Content
    
    @State private var keyboardHeight: CGFloat = 0
    var showDoneButton: Binding<Bool>
    
    private let showPublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardDidChangeFrameNotification
    ).map { (notification) -> CGFloat in
        if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            return rect.size.height
        } else {
            return 0
        }
    }
    
    private let hidePublisher = NotificationCenter.Publisher.init(
        center: .default,
        name: UIResponder.keyboardWillHideNotification
    ).map {_ -> CGFloat in 0}
    
    // Like HStack or VStack, the only parameter is the view that this view should layout.
    // (It takes one view rather than the multiple views that Stacks can take)
    init(showDoneButton: Binding<Bool>, @ViewBuilder content: () -> Content) {
        view = content()
        self.showDoneButton = showDoneButton
    }
    
    var body: some View {
        VStack {
            view
                .transition(.slide)
                .animation(.easeInOut)
                .offset(x: 0, y: 0 - keyboardHeight)
        }.onReceive(showPublisher.merge(with: hidePublisher)) { (height) in
            self.keyboardHeight = (height * 0.2) - 20
            print(keyboardHeight)
            
            if self.keyboardHeight + 20 == 0 || self.keyboardHeight > 100 {
                self.showDoneButton.wrappedValue = false
            }
        }
    }
}
