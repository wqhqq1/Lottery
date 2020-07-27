//
//  ContentView.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import SwiftUI

var MemberNumber = 0, i: Int = 0, MemberNames = [String](), originalMN = ""

struct ContentView: View {
    @State private var PrizeNumberInput = ""
    @State private var MemberNumberInput = ""
    @State private var MemberNamesInput = ""
    @State var selection: Int? = nil
    @State var showalert = false
    @State var showalertCPB = false
    var body: some View {
        NavigationView{
            KeyboardHost_offset3 {
            ScrollView {
        VStack {
            Text(NSLocalizedString("MNL", comment: "")).padding()
            TextField(NSLocalizedString("MNTF", comment: ""), text: $MemberNumberInput)
                .keyboardType(.numberPad)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                TextField(NSLocalizedString("NMTF", comment: ""), text: $MemberNamesInput)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    let Pboard = UIPasteboard.general
                    if Pboard.string != nil {
                        MemberNamesInput = NSLocalizedString("RFCB", comment: "")
                        originalMN = Pboard.string!
                        MemberNumberInput = String(MN_counter(input: originalMN))
                    }
                    else {
                        showalertCPB = true
                    }
                },
                       label: {
                        Image(systemName: "doc.on.clipboard")
                       })
                .alert(isPresented: $showalertCPB) {
                    Alert(title: Text("Fatal Error"), message: Text("Clip board is empty"), dismissButton: .default(Text("OK")))
                }
                .padding(.trailing)
            }
            NavigationLink(destination: page2_add(), tag: 1, selection: $selection) {
                Button(action: {
                    if MemberNamesInput != "" && MemberNumberInput != ""
                    {
//                        PrizeNumber = Int(PrizeNumberInput)!
                        MemberNumber = Int(MemberNumberInput)!
                        if originalMN != ""
                        {
                            MemberNames = MN_spliter(input: originalMN)
                        }
                        else {
                            MemberNames = MN_spliter_handinput(input: MemberNamesInput)
                        }
                        self.selection = 1
                    }
                    else {
                        showalert = true
                    }
                    i = 1
//                    self.selection = 1
//                    self.selection = 1
                }, label: {
                    Text(NSLocalizedString("NXTB", comment: ""))
                }).alert(isPresented: $showalert) {
                    Alert(title: Text("Fatal Error"), message: Text("Failed to read text fields"), dismissButton: .default(Text("OK")))
                }
            }.padding()
        }
            }.navigationBarTitle(NSLocalizedString("NBT1", comment: ""))
        }
        }.navigationViewStyle(StackNavigationViewStyle())}
}
