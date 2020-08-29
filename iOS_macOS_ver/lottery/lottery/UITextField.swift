//
//  UITextField.swift
//  lottery
//
//  Created by wqhqq on 2020/8/28.
//

import SwiftUI

struct NewTextField: UIViewRepresentable {
    
    let placeholder: String?
    let fontSize: CGFloat
    let borderStyle: UITextField.BorderStyle
    let cleanField: Bool
    let keyBoardType: UIKeyboardType
    let textLimit: Int?
    @Binding var updateNow: Bool
    @Binding var text: String
    
    init(_ placeholder: String? = nil, text: Binding<String>, updateNow: Binding<Bool> = .constant(false), textLimit:Int? = nil, fontSize: CGFloat = 17.5, style: UITextField.BorderStyle = .none, cleanField: Bool = false, keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self._text = text
        self.fontSize = fontSize
        self.borderStyle = style
        self.cleanField = cleanField
        self.keyBoardType = keyboardType
        self.textLimit = textLimit
        self._updateNow = updateNow
    }
    
    func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.font = .systemFont(ofSize: self.fontSize)
        view.textColor = UIColor(named: "trash")
        view.placeholder = self.placeholder
        view.text = self.text
        view.borderStyle = self.borderStyle
        view.delegate = context.coordinator
        view.keyboardType = self.keyBoardType
        return view
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if self.updateNow {
            uiView.text = self.text
            self.updateNow = false
        }
        return
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: NewTextField
        var width: CGFloat = 0, firstChange = true
        init(_ view: NewTextField) {
            parent = view
        }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string == "\n" {
                UIApplication.shared.endEditing()
                return true
            }
            let willUpdateText = textField.text == nil ? "":textField.text!
            guard let currentRange = Range(range, in: willUpdateText) else {return false}
            let updatedText = willUpdateText.replacingCharacters(in: currentRange, with: string)
            if let limit = parent.textLimit {
                if limit < updatedText.lengthOfBytes(using: .utf8) {
                    return false
                }
            }
            parent.text = updatedText
            return true
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            if parent.cleanField {
                textField.text = ""
                parent.text = ""
            }
        }
    }
    
}

struct test: View {
    @State var textInput = ""
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                NewTextField("placeholder", text: self.$textInput)
            }.frame(height: 30).padding()
            Text(self.textInput)
        }
    }
}

struct UITextField_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
