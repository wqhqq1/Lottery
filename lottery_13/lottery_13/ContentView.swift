//
//  ContentView.swift
//  lottery_13
//
//  Created by wqhqq on 2020/7/20.
//

import SwiftUI

var PrizeNumber = 0, MemberNumber = 0, i: Int = 0, MemberNames = [String](), originalMN = ""

struct ContentView: View {
    @State private var PrizeNumberInput = ""
    @State private var MemberNumberInput = ""
    @State private var MemberNamesInput = ""
    @State var selection: Int? = nil
    @State var showalert = false
    @State var showalertCPB = false
    var body: some View {
        NavigationView{
            KeyboardHost {
            ScrollView {
        VStack {
            Text("输入奖项数量").padding()
            TextField("奖项数量", text: $PrizeNumberInput).padding()
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("输入参与抽奖的人数").padding()
            TextField("抽奖人数", text: $MemberNumberInput)
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                TextField("抽奖人员名单", text: $MemberNamesInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    let Pboard = UIPasteboard.general
                    if Pboard.string != nil {
                        MemberNamesInput = "pasted from clipboard!"
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
                    Alert(title: Text("Fatal Error"), message: Text("Clip board is empty yet"), dismissButton: .default(Text("OK")))
                }
            }.padding()
            NavigationLink(destination: page2(), tag: 1, selection: $selection) {
                Button(action: {
                    if PrizeNumberInput != "" && MemberNamesInput != "" && MemberNumberInput != ""
                    {
                        PrizeNumber = Int(PrizeNumberInput)!
                        MemberNumber = Int(MemberNumberInput)!
                        if originalMN != ""
                        {
                            MemberNames = MN_spliter(input: originalMN)
                        }
                        else {
                            MemberNames = MN_spliter(input: MemberNamesInput)
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
                    Text("下一步")
                }).alert(isPresented: $showalert) {
                    Alert(title: Text("Fatal Error"), message: Text("Failed to read text fields"), dismissButton: .default(Text("OK")))
                }
            }.padding()
        }
            }.navigationBarTitle("抽奖器")
        }
        }.navigationViewStyle(StackNavigationViewStyle())}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
