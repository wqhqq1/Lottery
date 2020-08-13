//
//  ContentView.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import SwiftUI

var MemberNumber = 0, i: Int = 0, MemberNames = [String](), originalMN = "", readyToCopy = "", originalMemberNames = "", addCmd = [Int](), addedCmd = false, originCmd = ""

struct ContentView: View {
    @State private var PrizeNumberInput = ""
    @State private var MemberNumberInput = ""
    @State private var MemberNamesInput = ""
    @State var selection: Int? = nil
    @State var showalert = false
    @State var showalertCPB = false
    @State var showADDTF = false
    @State var addCmdInput = ""
    var body: some View {
        let membernames = Binding<String>(get: {
            self.MemberNamesInput
        }, set: {
            self.MemberNamesInput = $0
            if self.MemberNamesInput != "" {
                if self.MemberNamesInput != NSLocalizedString("RFCB", comment: "") {
                    self.MemberNumberInput = String(MN_counter_handinput(input: self.MemberNamesInput))
                    print(originalMN)
                }
            }
            else {
                self.MemberNumberInput = ""
            }
        })
        return NavigationView{
            KeyboardHost_offset20 {
                VStack {
                    Form {
                        Section {
                            HStack {
                                Spacer()
                                Image("box")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                Spacer()
                            }
                            TextField(NSLocalizedString("MNTF", comment: ""), text: $MemberNumberInput)
                                .keyboardType(.numberPad)
                                .padding(.horizontal)
                            HStack {
                                TextField(NSLocalizedString("NMTF", comment: ""), text: membernames)
                                    .padding(.leading)
                                Button(action: {
                                    let Pboard = UIPasteboard.general
                                    if Pboard.string != nil {
                                        self.MemberNamesInput = NSLocalizedString("RFCB", comment: "")
                                        originalMN = Pboard.string!
                                        self.MemberNumberInput = String(MN_counter(input: Pboard.string!))
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
                        Section {
                            HStack {
                                Text(NSLocalizedString("ADDCT", comment: ""))
                                    .font(.headline)
                                    .padding(.leading)
                                Spacer()
                                Toggle(isOn: self.$showADDTF) {
                                    Text("")
                                }.padding(.trailing)
                            }
                            if self.showADDTF {
                                HStack {
                                    TextField(NSLocalizedString("ADDCTF", comment: ""), text: self.$addCmdInput)
                                    Button(action: {
                                        let Pboard = UIPasteboard.general
                                        if Pboard.string != nil {
                                            originCmd = Pboard.string!
                                            self.addCmdInput = NSLocalizedString("RFCB", comment: "")
                                            
                                        }
                                        else {
                                            self.showalertCPB = true
                                        }
                                    },
                                           label: {
                                            Image(systemName: "doc.on.clipboard")
                                    })
                                        .padding(.horizontal)
                                        .alert(isPresented: $showalertCPB) {
                                            Alert(title: Text("Fatal Error"), message: Text("Clip board is empty"), dismissButton: .default(Text("OK")))
                                    }
                                }.padding(.leading)
                                .transition(.slide)
                            }
                        }
                        
                    }
                }
                NavigationLink(destination: page2_add(), tag: 1, selection: $selection) {
                    Button(action: {
                        if self.MemberNamesInput != "" && self.MemberNumberInput != ""
                        {
                            //                        PrizeNumber = Int(PrizeNumberInput)!
                            MemberNumber = Int(self.MemberNumberInput)!
                            if self.MemberNamesInput == NSLocalizedString("RFCB", comment: "")
                            {
                                MemberNames = MN_spliter(input: originalMN)
                            }
                            else {
                                MemberNames = MN_spliter_handinput(input: self.MemberNamesInput)
                            }
                            originalMemberNames = self.MemberNamesInput
                            if self.showADDTF && AG_counter(addCmds: originCmd) == MemberNumber {
                                addCmd = AG_spliter(addCmds: originCmd)
                                addedCmd = self.showADDTF
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
    @State private var MemberNumberInput = String(MemberNumber)
    @State private var MemberNamesInput = originalMemberNames
    @State var selection: Int? = nil
    @State var showalert = false
    @State var showalertCPB = false
    @State var showADDTF = addedCmd
    @State var addCmdInput = addedCmd ? NSLocalizedString("RFCB", comment: ""):""
    var body: some View {
        let membernames = Binding<String>(get: {
            self.MemberNamesInput
        }, set: {
            self.MemberNamesInput = $0
            if self.MemberNamesInput != "" {
                self.MemberNumberInput = String(MN_counter_handinput(input: self.MemberNamesInput))
            }
            else {
                self.MemberNumberInput = ""
            }
        })
        return KeyboardHost_offset20 {
            VStack {
                Form {
                    Section {
                        HStack {
                            Spacer()
                            Image("box")
                                .resizable()
                                .frame(width: 150, height: 150)
                            Spacer()
                        }
                        TextField(NSLocalizedString("MNTF", comment: ""), text: $MemberNumberInput)
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                        HStack {
                            TextField(NSLocalizedString("NMTF", comment: ""), text: membernames)
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
                    Section {
                        HStack {
                            Text(NSLocalizedString("ADDCT", comment: ""))
                                .font(.headline)
                                .padding(.leading)
                            Spacer()
                            Toggle(isOn: self.$showADDTF) {
                                Text("")
                            }.padding(.trailing)
                        }
                        if self.showADDTF {
                            HStack {
                                TextField(NSLocalizedString("ADDCTF", comment: ""), text: self.$addCmdInput)
                                Button(action: {
                                    let Pboard = UIPasteboard.general
                                    if Pboard.string != nil {
                                        originCmd = Pboard.string!
                                        self.addCmdInput = NSLocalizedString("RFCB", comment: "")
                                        
                                    }
                                    else {
                                        self.showalertCPB = true
                                    }
                                },
                                       label: {
                                        Image(systemName: "doc.on.clipboard")
                                })
                                    .padding(.horizontal)
                                    .alert(isPresented: $showalertCPB) {
                                        Alert(title: Text("Fatal Error"), message: Text("Clip board is empty"), dismissButton: .default(Text("OK")))
                                }
                            }.padding(.leading)
                        }
                    }
                    
                }
            }
            NavigationLink(destination: page2_add(), tag: 1, selection: $selection) {
                Button(action: {
                    if self.MemberNamesInput != "" && self.MemberNumberInput != ""
                    {
                        //                        PrizeNumber = Int(PrizeNumberInput)!
                        MemberNumber = Int(self.MemberNumberInput)!
                        if self.MemberNamesInput == NSLocalizedString("RFCB", comment: "")
                        {
                            MemberNames = MN_spliter(input: originalMN)
                        }
                        else {
                            MemberNames = MN_spliter_handinput(input: self.MemberNamesInput)
                        }
                        originalMemberNames = self.MemberNamesInput
                        if self.showADDTF && AG_counter(addCmds: originCmd) == MemberNumber {
                            addCmd = AG_spliter(addCmds: originCmd)
                            addedCmd = self.showADDTF
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
