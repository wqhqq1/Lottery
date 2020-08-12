//
//  UIKitAlertController.swift
//  lottery
//
//  Created by wqhqq on 2020/8/7.
//

import SwiftUI

struct AlertControl: UIViewControllerRepresentable {

    @State var textString: String = ""
    @Binding var show: Bool

    var title: String
    var message: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControl>) -> UIViewController {
        return UIViewController() // holder controller - required to present alert
    }

    func updateUIViewController(_ viewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControl>) {
        guard context.coordinator.alert == nil else { return }
        if self.show {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = alert

            alert.addTextField { textField in
                textField.placeholder = "File name here."
                textField.text = self.textString            // << initial value if any
                textField.delegate = context.coordinator    // << use coordinator as delegate
                textField.font = UIFont(name: "PingFangTC-Regular", size: 20)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                // your action here
            })
            alert.addAction(UIAlertAction(title: "Save", style: .destructive) { _ in
                if self.textString != "" {
                    var path = ""
                    if #available(iOS 13.0, *) {
                        path = NSHomeDirectory() + "/Documents/\(self.textString).csv"
                        print(path)
                    }
                    if #available(OSX 10.15, *)
                    {
                        path = "/Users/Shared/\(self.textString).csv"
                    }
                    try? readyToCopy.write(toFile: path, atomically: true, encoding: .utf8)
                }
            })

            DispatchQueue.main.async { // must be async !!
                viewController.present(alert, animated: true, completion: {
                    self.show = false  // hide holder after alert dismiss
                    context.coordinator.alert = nil
                })
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
            if let text = textField.text as NSString? {
                self.control.textString = text.replacingCharacters(in: range, with: string)
            } else {
                self.control.textString = ""
            }
            return true
        }
    }
}

