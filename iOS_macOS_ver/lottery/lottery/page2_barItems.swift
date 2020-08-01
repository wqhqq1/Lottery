//
//  page2_barItems.swift
//  lottery
//
//  Created by wqhqq on 2020/7/31.
//

import SwiftUI

struct page2_barItems: View {
    @Binding var isEditingMode: Bool
    @State var showAlert: Bool = false
    @Binding var showButton: Bool
    @Binding var showRemoveButton: [Bool]
    @Binding var selected: [Int]
    @EnvironmentObject var PrizeData: Prizes
    var body: some View {
        HStack {
            Spacer()
            if isEditingMode {
                Button(action : {
                    self.showAlert = true
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(Color("trash"))
                        .imageScale(.large)
                        .padding(.trailing)
                }
                .actionSheet(isPresented: self.$showAlert) {
                    ActionSheet(title: Text(NSLocalizedString("RMT", comment: "")), message: Text(NSLocalizedString("CRMT", comment: "")),
                                buttons: [.destructive(Text(NSLocalizedString("RMT", comment: ""))) {
                                    self.PrizeData.removeMore(index: self.selected)
                                    self.selected = []
                        }])
                }
            }
            Button(action: {
                self.showButton.toggle()
                var i = 0
                while i < self.showRemoveButton.count {
                    self.showRemoveButton[i].toggle()
                    i += 1
                }
                self.isEditingMode.toggle()
                self.selected.removeAll()
            }){
                Text(isEditingMode ? NSLocalizedString("DONE", comment: ""):NSLocalizedString("EDIT", comment: ""))
                    .font(.custom("", size: 20))
                    .fontWeight(.heavy)
                    .padding([.trailing, .top])
            }
        }
    }
}
