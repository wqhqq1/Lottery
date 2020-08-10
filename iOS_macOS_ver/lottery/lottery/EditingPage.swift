//
//  EditingPage.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import SwiftUI

struct EditingPage: View {
    @EnvironmentObject var PrizeData: Prizes
    @Environment(\.presentationMode) var presentation
    @State var prizename = ""
    @State var prizequota = ""
    @State var showalert = false
    var index: Int?
    @Binding var prizeHead: Int
    @Binding var prizeEnd: Int
    @State var showADDCTF: Bool
    @State var maxCmd: String = ""
    @State var minCmd: String = ""
    var body: some View {
        KeyboardHost_edit {
            NavigationView {
                Form {
                    Section(header: Text(NSLocalizedString("PT", comment: ""))) {
                        TextField(NSLocalizedString("PTF", comment: ""), text: $prizename)
                        TextField(NSLocalizedString("PNTTF", comment: ""), text: $prizequota)
                            .keyboardType(.numberPad)
                    }
                    
                    if addedCmd {
                        Section {
                            HStack {
                                Text(NSLocalizedString("ADDCT", comment: ""))
                                Toggle(isOn: self.$showADDCTF, label: {
                                    Text("")
                                })
                            }.padding(.horizontal)
                            if self.showADDCTF {
                                TextField("\(NSLocalizedString("ADDCTF", comment: ""))Max", text: self.$maxCmd)
                                    .padding(.horizontal)
                                TextField("\(NSLocalizedString("ADDCTF", comment: ""))Min", text: self.$minCmd)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    Section {
                        Button(action: {
                            if self.prizequota != "" {
                                if self.index == nil {
                                    self.PrizeData.add(data: SinglePrize(PrizeName: self.prizename, PrizeMember: Int(self.prizequota)!, maxCmd: (self.showADDCTF && self.maxCmd != "") ? Int(self.maxCmd)!:nil, minCmd: (self.showADDCTF && self.minCmd != "") ? Int(self.minCmd)!:nil, enabledCmds: (self.showADDCTF && self.maxCmd != "" && self.minCmd != "") ? true:false))
                                    self.prizeHead = self.PrizeData.head()
                                    self.prizeEnd = self.PrizeData.end()
                                }
                                else {
                                    self.PrizeData.edit(index: self.index!, data: SinglePrize(PrizeName: self.prizename, PrizeMember: Int(self.prizequota)!, maxCmd: (self.showADDCTF && self.maxCmd != "") ? Int(self.maxCmd):nil, minCmd: (self.showADDCTF && self.minCmd != "") ? Int(self.minCmd):nil, enabledCmds: (self.showADDCTF && self.minCmd != "" && self.maxCmd != "") ? true:false))
                                }
                                self.presentation.wrappedValue.dismiss()
                            }
                            else {
                                self.showalert = true
                            }
                        }){
                            Text(NSLocalizedString("EXT", comment: ""))
                        }.alert(isPresented: $showalert) {
                            Alert(title: Text("Fatal Error"), message: Text("Unable to read text fields!"), dismissButton: .default(Text("OK")))
                        }
                        Button(action: {
                            self.presentation.wrappedValue.dismiss()
                        }){
                            Text(NSLocalizedString("CANL", comment: ""))
                        }
                    }
                }.navigationBarTitle(index == nil ? NSLocalizedString("ADD", comment: ""):NSLocalizedString("EDIT", comment: ""))
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


