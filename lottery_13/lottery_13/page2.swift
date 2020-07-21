//
//  page2.swift
//  lottery_13
//
//  Created by wqhqq on 2020/7/20.
//

import SwiftUI

var Prizes = [prizes]()
struct page2: View {
    @State private var PrizeNames: String = ""
    @State private var PrizeMembers: String = ""
    @State var selection: Int? = nil
    @State var showalert = false
    var body: some View {
        KeyboardHost {
        ScrollView{
        if i <= PrizeNumber {
            VStack{
                Text("奖项\(i)")
                    .padding()
                TextField("奖项名称", text: $PrizeNames)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("获奖名额", text: $PrizeMembers)
                    .keyboardType(.numberPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                NavigationLink(destination: page2(), tag: 1, selection: $selection) {
                    Button(action: {
                        if PrizeNames != "" && PrizeMembers != "" {
                        Prizes.append(.init(PrizeName: PrizeNames,
                                            PrizeMember: Int(PrizeMembers)!))
                        i += 1
                        selection = 1
                        }
                        else {
                            showalert = true
                        }
                    }, label: {
                        Text("下一步")
                    }).alert(isPresented: $showalert) {
                        Alert(title: Text("Fatal Error"), message: Text("Failed to read text fields"), dismissButton: .default(Text("OK")))
                    }
                }.padding()
            }
        }
        else {
            VStack{
                Text("奖项\(i)")
                    .padding()
                TextField("奖项名称", text: $PrizeNames)
                    .padding()
                TextField("获奖名额", text: $PrizeMembers)
                    .keyboardType(.numberPad)
                    .padding()
                NavigationLink(destination: page3_confirm(), tag: 1, selection: $selection) {
                    Button(action: {
                        i = 0
                        selection = 1
                    }, label: {
                        Text("完成")
                    })
                }.padding()
            }
        }
        }}
    }
}

struct page2_Previews: PreviewProvider {
    static var previews: some View {
        page2()
    }
}
