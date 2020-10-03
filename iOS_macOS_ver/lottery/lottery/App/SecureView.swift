//
//  SecureView.swift
//  lottery
//
//  Created by wqhqq on 2020/9/26.
//

import SwiftUI
import WidgetKit

struct SecureView: View {
    @State var passwd = ""
    @State var passwdForVerify = ""
    @State var hash: String? = nil
    @State var updateNow = false
    @State var updateNow2 = false
    @State var verifying = false
    @State var showAlert = false
    @State var showAlertShort = false
    var body: some View {
        return NavigationView{ ZStack {
            BlurView()
            Form {
                Button(action: {
                    if hash != nil {
                        self.verifying = true
                    }
                    else {
                        if passwd != "" {
                            hash = sha256(passwd)
                            pwdHash = hash
                            UserDefaults.standard.set(pwdHash, forKey: "pwdHash")
                            passwd = ""
                            self.updateNow = true
                            var sharedDir = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.lotterywiget")!
                            sharedDir.appendPathComponent("pwdState")
                            let state = "1"
                            try! state.write(to: sharedDir, atomically: true, encoding: .utf8)
                        }
                        else {
                            self.showAlertShort = true
                        }
                    }
                    WidgetCenter.shared.reloadAllTimelines()
                }) {
                    Text(hash != nil ? (verifying ? "Verifying...":"Close"):"Set").foregroundColor(verifying ? .black:.blue)
                }.alert(isPresented: self.$showAlertShort, content: {
                    Alert(title: Text("Password too short"), message: Text("You can try another password."), dismissButton: .default(Text("OK")))
                })
                if !verifying{
                    NewTextField(.constant(hash != nil ? "You're all set":"Password"), text: self.$passwd, updateNow: self.$updateNow, isSecure: .constant(true), isDisabled: .constant(hash != nil ? true:false))
                }
                if verifying {
                    NewTextField(.constant("Password"), text: self.$passwdForVerify, updateNow: self.$updateNow2, isSecure: .constant(true))
                    Button(action:{
                        if sha256(self.passwdForVerify) == pwdHash {
                            hash = nil
                            pwdHash = nil
                            passwd = ""
                            self.updateNow = true
                            UserDefaults.standard.set(pwdHash, forKey: "pwdHash")
                            var sharedDir = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.lotterywiget")!
                            sharedDir.appendPathComponent("pwdState")
                            let state = "0"
                            try! state.write(to: sharedDir, atomically: true, encoding: .utf8)
                            self.verifying = false
                            self.passwdForVerify = ""
                            self.updateNow2 = true
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                        else {
                            self.showAlert = true
                        }
                    }) {
                        Text(NSLocalizedString("DONE", comment: ""))
                    }.alert(isPresented: self.$showAlert, content: {
                        Alert(title: Text("Wrong Password"), message: Text("You can try again or cancel"), dismissButton: .default(Text("OK")))
                    })
                    Button(action: {
                        self.verifying = false
                        self.passwdForVerify = ""
                        self.updateNow2 = true
                    }) {
                        Text("Cancel")
                    }
                }
            }.navigationBarTitle(NSLocalizedString("SecNB", comment: "secure"))
        }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SecureView_Previews: PreviewProvider {
    static var previews: some View {
        SecureView()
    }
}
