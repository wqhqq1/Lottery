//
//  endEditing.swift
//  lottery
//
//  Created by wqhqq on 2020/8/14.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
