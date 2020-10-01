//
//  UIKitAlertController.swift
//  lottery
//
//  Created by wqhqq on 2020/8/7.
//

import SwiftUI
import LocalAuthentication

var pwdHash: String? = nil
func sha256(_ string : String) -> String {
    var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
    let data = string.data(using: .utf8)!
    data.withUnsafeBytes {
        _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
    }
    return Data(hash).base64EncodedString()
}


struct AlertControl: UIViewControllerRepresentable {
    
    @State var textString: String = ""
    @Binding var show: Bool
    @Binding var correct: Bool
    
    var title: String
    var message: String
    @State var once = false
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControl>) -> UIViewController {
        return UIViewController() // holder controller - required to present alert
    }
    
    func updateUIViewController(_ viewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControl>) {
        guard context.coordinator.alert == nil else { return }
        if self.show {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let wrongAlert = UIAlertController(title: "Incorrect", message: "Password you input is incorrect, please try another one.", preferredStyle: .alert)
            wrongAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                DispatchQueue.main.async {
                    viewController.present(alert, animated: true, completion: {
                        self.show = false
                        context.coordinator.alert = nil
                    })
                }
            }))
            context.coordinator.alert = alert
            
            alert.addTextField { textField in
                textField.placeholder = "Password"
                textField.text = self.textString            // << initial value if any
                textField.delegate = context.coordinator    // << use coordinator as delegate
                textField.font = UIFont(name: "PingFangTC-Regular", size: 20)
                textField.isSecureTextEntry = true
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                // your action here
                textString = ""
            })
            alert.addAction(UIAlertAction(title: "Unlock", style: .destructive) { _ in
                if sha256(textString) == pwdHash {
                    self.correct = true
                }
                else {
                    self.correct = false
                    DispatchQueue.main.async {
                        viewController.present(wrongAlert, animated: true, completion: {
                            self.show = false
                            context.coordinator.alert = nil
                        })
                    }
                }
                textString = ""
            })
            
            DispatchQueue.main.async { // must be async !!
                if pwdHash == nil && !once {
                    self.correct = true
                }
                else {
                    let authenticationContext = LAContext()
                    authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Data unlocker", reply:
                    {(success, error) -> Void in
                        if success
                        {
                            DispatchQueue.main.async {
                                self.correct = true
                                self.show = false
                                context.coordinator.alert = nil
                            }
                            return
                        }
                        else {
//                            print(error)
                            DispatchQueue.main.async {
                                viewController.present(alert, animated: true, completion: {
                                    self.show = false  // hide holder after alert dismiss
                                    context.coordinator.alert = nil
                                })
                            }
                        }
                    })
            }
        }
    }
}

func makeCoordinator() -> AlertControl.Coordinator {
    Coordinator(self)
}

class Coordinator: NSObject, UITextFieldDelegate {
    var alert: UIAlertController?
    var control: AlertControl
    init(_ control: AlertControl) {
        self.control = control
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            return false
        }
        if let text = textField.text as NSString? {
            self.control.textString = text.replacingCharacters(in: range, with: string)
        } else {
            self.control.textString = ""
        }
        return true
    }
}
}

