//
//  UITextField.swift
//  lottery
//
//  Created by wqhqq on 2020/8/28.
//

import SwiftUI

struct NewTextField: UIViewRepresentable {
    
    let placeholder: String
    let fontSize: CGFloat
    let borderStyle: UITextField.BorderStyle
    let cleanField: Bool
    let keyBoardType: UIKeyboardType
    let textLimit: Int?
    let fontColor: UIColor?
    @Binding var updateNow: Bool
    @Binding var isDisabled: Bool?
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>, updateNow: Binding<Bool> = .constant(false), isDisabled: Binding<Bool?> = .constant(nil), textLimit:Int? = nil, fontSize: CGFloat = 17.5, fontColor: UIColor? = .black, style: UITextField.BorderStyle = .none, cleanField: Bool = false, keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self._text = text
        self.fontSize = fontSize
        self.borderStyle = style
        self.cleanField = cleanField
        self.keyBoardType = keyboardType
        self.textLimit = textLimit
        self._updateNow = updateNow
        self.fontColor = fontColor
        self._isDisabled = isDisabled
    }
    
    func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.font = .systemFont(ofSize: self.fontSize)
        view.textColor = .black
        view.placeholder = self.placeholder
        view.text = self.text
        view.borderStyle = self.borderStyle
        view.delegate = context.coordinator
        view.keyboardType = self.keyBoardType
        view.tintColor = .black
        return view
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if self.updateNow {
            uiView.text = self.text
            self.updateNow = false
        }
        if let isDisabled = self.isDisabled {
            uiView.isEnabled = !isDisabled
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

struct fullBG: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemRed
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        return
    }
}

struct test: View {
    @State var textInput = ""
    @State var isDisabled: Bool? = false
    var body: some View {
        VStack() {
//            ScrollView(.horizontal, showsIndicators: false) {
                NewTextField("placeholder", text: self.$textInput, isDisabled: self.$isDisabled, fontColor: .systemRed, style: .none)
                    .frame(height: 30)
//            }.frame(width: 100, height: 30)
            Button(action: {
                self.isDisabled?.toggle()
            }) {
                Text("toggle")
            }
        }.padding()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct UITextField_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
