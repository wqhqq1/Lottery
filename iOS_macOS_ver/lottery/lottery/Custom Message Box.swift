//
//  Custom Message Box.swift
//  lottery
//
//  Created by wqhqq on 2020/8/31.
//

import SwiftUI

struct CustomMessageBox: View {
    let message: String
    let lines: CGFloat
    @Binding var show: Bool
    @State var timer = Timer.TimerPublisher(interval: 1.5, runLoop: .main, mode: .default).autoconnect()
    
    init(_ message: String, show: Binding<Bool>, lines: CGFloat = 1) {
        self.message = message
        self.lines = lines
        self._show = show
    }
    
    var body: some View {
        if show {
            timer = Timer.TimerPublisher(interval: 2, runLoop: .main, mode: .default).autoconnect()
        }
        return self.show ? VStack {Spacer();Button(action: {
            self.show = false
        }){ZStack {
            Rectangle()
                .frame(width: show ? 10*CGFloat(message.lengthOfBytes(using: .utf8))/lines:0, height: 25*lines)
                .foregroundColor(.gray)
                .cornerRadius(12.5*lines)
                .opacity(0.8)
            Text(message)
                .foregroundColor(.white)
                .font(.subheadline)
        }.padding(.bottom, 2)
        .onReceive(timer) { _ in
            self.show = false
            timer.upstream.connect().cancel()
        }}}
        .transition(.offset(x: 0, y: 25*lines + 2))
        .animation(.easeInOut(duration: 0.5)) : nil
    }
}

struct testmessage: View {
    @State var show = false
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.show = true
                }
            }) {
                Text("toggle")
            }
            Spacer()
            CustomMessageBox("Pasted from\nclip board", show: self.$show, lines: 2)
        }
    }
}

struct Custom_Message_Box_Previews: PreviewProvider {
    static var previews: some View {
        testmessage()
    }
}
