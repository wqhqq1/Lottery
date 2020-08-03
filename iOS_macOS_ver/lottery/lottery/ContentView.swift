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
            KeyboardHost_offset20 {
                Form {
                    Section {
                        TextField(NSLocalizedString("MNTF", comment: ""), text: $MemberNumberInput)
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                        HStack {
                            TextField(NSLocalizedString("NMTF", comment: ""), text: $MemberNamesInput)
                                .padding(.leading)
                            Button(action: {
                                let Pboard = UIPasteboard.general
                                if Pboard.string != nil {
                                    self.MemberNamesInput = NSLocalizedString("RFCB", comment: "")
                                    originalMN = Pboard.string!
                                    self.MemberNumberInput = String(MN_counter(input: originalMN))
                                }
                                else {
                                    self.showalertCPB = true
                                }
                            },
                                   label: {
                                    Image(systemName: "doc.on.clipboard")
                            })
                                .alert(isPresented: $showalertCPB) {
                                    Alert(title: Text("Fatal Error"), message: Text("Clip board is empty"), dismissButton: .default(Text("OK")))
                            }
                            .padding(.trailing)
                        }}
                    
                }
                NavigationLink(destination: page2_add(), tag: 1, selection: $selection) {
                    Button(action: {
                        if self.MemberNamesInput != "" && self.MemberNumberInput != ""
                        {
                            //                        PrizeNumber = Int(PrizeNumberInput)!
                            MemberNumber = Int(self.MemberNumberInput)!
                            if originalMN != ""
                            {
                                MemberNames = MN_spliter(input: originalMN)
                            }
                            else {
                                MemberNames = MN_spliter_handinput(input: self.MemberNamesInput)
                            }
                            self.selection = 1
                        }
                        else {
                            self.showalert = true
                        }
                        //                                i = 1
                        //                    self.selection = 1
                        //                    self.selection = 1
                    }, label: {
                        Text(NSLocalizedString("NXTB", comment: ""))
                            .background(Color("nextButton"))
                    }).alert(isPresented: $showalert) {
                        Alert(title: Text("Fatal Error"), message: Text("Failed to read text fields"), dismissButton: .default(Text("OK")))
                    }
                    .padding()
                }
            }
            .navigationBarTitle(NSLocalizedString("NBT1", comment: ""))
        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_back: View {
    @State private var PrizeNumberInput = ""
    @State private var MemberNumberInput = ""
    @State private var MemberNamesInput = ""
    @State var selection: Int? = nil
    @State var showalert = false
    @State var showalertCPB = false
    var body: some View {
        
        KeyboardHost_offset20 {
            Form {
                Section {
                    TextField(NSLocalizedString("MNTF", comment: ""), text: $MemberNumberInput)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                    HStack {
                        TextField(NSLocalizedString("NMTF", comment: ""), text: $MemberNamesInput)
                            .padding(.leading)
                        Button(action: {
                            let Pboard = UIPasteboard.general
                            if Pboard.string != nil {
                                self.MemberNamesInput = NSLocalizedString("RFCB", comment: "")
                                originalMN = Pboard.string!
                                self.MemberNumberInput = String(MN_counter(input: originalMN))
                            }
                            else {
                                self.showalertCPB = true
                            }
                        },
                               label: {
                                Image(systemName: "doc.on.clipboard")
                        })
                            .alert(isPresented: $showalertCPB) {
                                Alert(title: Text("Fatal Error"), message: Text("Clip board is empty"), dismissButton: .default(Text("OK")))
                        }
                        .padding(.trailing)
                    }}
                
            }
            NavigationLink(destination: page2_add(), tag: 1, selection: $selection) {
                Button(action: {
                    if self.MemberNamesInput != "" && self.MemberNumberInput != ""
                    {
                        //                        PrizeNumber = Int(PrizeNumberInput)!
                        MemberNumber = Int(self.MemberNumberInput)!
                        if originalMN != ""
                        {
                            MemberNames = MN_spliter(input: originalMN)
                        }
                        else {
                            MemberNames = MN_spliter_handinput(input: self.MemberNamesInput)
                        }
                        self.selection = 1
                    }
                    else {
                        self.showalert = true
                    }
                    //                                i = 1
                    //                    self.selection = 1
                    //                    self.selection = 1
                }, label: {
                    Text(NSLocalizedString("NXTB", comment: ""))
                        .background(Color("nextButton"))
                }).alert(isPresented: $showalert) {
                    Alert(title: Text("Fatal Error"), message: Text("Failed to read text fields"), dismissButton: .default(Text("OK")))
                }
                .padding()
            }
        }
        .navigationBarTitle(NSLocalizedString("NBT1", comment: ""))
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
}
