//
//  ShareSheet.swift
//  lottery
//
//  Created by wqhqq on 2020/9/11.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    init(_ activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityView = UIActivityViewController(activityItems: self.activityItems, applicationActivities: self.applicationActivities)
        return activityView
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        return
    }
}
