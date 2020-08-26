//
//  ContentView.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import SwiftUI


func dataLoader() -> [SinglePrize] {
    var output: [SinglePrize] = []
    if let data = UserDefaults.standard.object(forKey: "PrizeList_cacu") as? Data {
        output = try! decoder.decode([SinglePrize].self, from: data)
        let time = UserDefaults.standard.string(forKey: "theDate")
        lastTime  = time!
        let readyTC = UserDefaults.standard.object(forKey: "readyToCopy") as! Data
        readyToCopy = try! decoder.decode(String.self, from: readyTC)
        print(FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.lotterywiget")!)
    }
    return output
}


struct ContentView: View {
    @State private var PrizeNumberInput = ""
    @State private var MemberNumberInput = ""
    @State private var MemberNamesInput = ""
    @State var selection: Int? = nil
    @State var showalert = false
    @State var showalertCPB = false
    @State var showADDTF = false
    @State var addCmdInput = ""
    @State var lastResult = Prizes(data: dataLoader())
    @State var showSheet = false
    @State var showWarning = false
    @State var showLastRButton = true
    @State var showDoneButton = false
    @ObservedObject var PrizeData = Prizes.init()
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
        return GeometryReader { geo in
            NavigationView{
                VStack {
                    KeyboardHost_offset20(showDoneButton: self.$showDoneButton, showButton: self.$showLastRButton)  {
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
                        
                        ZStack {
                            HStack {
                                NavigationLink(destination: page2_add(PrizeData: PrizeData), tag: 1, selection: $selection) {
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
                            HStack {
                                Spacer()
                                if self.showDoneButton {
                                    Button(action: {
                                        self.showDoneButton = false
                                        UIApplication.shared.endEditing()
                                    }) {
                                        Text(NSLocalizedString("DONE", comment: ""))
                                    }.padding()
                                }
                            }
                        }}
                    if showLastRButton {
                        HStack {
                            Spacer()
                            Button(action: {
                                if self.lastResult.PrizeList_cacu.count != 0 {
                                    sheetModeResult = true
                                    self.showSheet = true
                                }
                                else {
                                    self.showWarning = true
                                }
                            }) {
                                ZStack {
                                    Rectangle()
                                        .cornerRadius(50)
                                        .foregroundColor(Color("CardBG"))
                                        .shadow(color: Color("Shadow"), radius: 10)
                                        .frame(width: 200, height: 80)
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(NSLocalizedString("LastR", comment: ""))
                                                .font(.headline)
                                                .foregroundColor(Color("trash"))
                                                .padding(.bottom, 5)
                                            Text(lastTime)
                                                .foregroundColor(Color("trash"))
                                        }
                                        .padding(.leading, 33)
                                        Spacer()
                                        Image(systemName: "chevron.right.circle.fill")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .padding(7)
                                    }
                                }
                            }
                            .sheet(isPresented: self.$showSheet) {
                                resultReplay().environmentObject(self.lastResult)
                            }
                            .alert(isPresented: self.$showWarning, content: {
                                Alert(title: Text("Failed"), message: Text("No result"), dismissButton: .default(Text("OK")))
                            })
                            Spacer()
                        }.frame(width: 200, height: 80)
                        .padding(.bottom)
                    }
                    
                }
                .navigationBarTitle(NSLocalizedString("NBT1", comment: ""))
            }.navigationViewStyle(StackNavigationViewStyle())
            .padding(.bottom)
            .frame(maxHeight: 800)
            .navigationBarBackButtonHidden(true)
            .offset(x: 0, y: geo.size.height > 800 ? geo.size.height - 780:0)
        }
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
    @State var showSheet = false
    @State var showWarning = false
    @State var showLastRButton = true
    @State var showDoneButton = false
    @ObservedObject var PrizeData = Prizes.init()
    var lastResult = Prizes(data: dataLoader())
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
        return GeometryReader { geo in
            VStack {
                KeyboardHost_offset20(showDoneButton: self.$showDoneButton, showButton: self.$showLastRButton)  {
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
                    
                    ZStack {
                        HStack {
                            NavigationLink(destination: page2_add(PrizeData: PrizeData), tag: 1, selection: $selection) {
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
                        HStack {
                            Spacer()
                            if self.showDoneButton {
                                Button(action: {
                                    self.showDoneButton = false
                                    UIApplication.shared.endEditing()
                                }) {
                                    Text(NSLocalizedString("DONE", comment: ""))
                                }.padding()
                            }
                        }
                    }}
                if showLastRButton {
                    HStack {
                        Spacer()
                        Button(action: {
                            if self.lastResult.PrizeList_cacu.count != 0 {
                                sheetModeResult = true
                                self.showSheet = true
                            }
                            else {
                                self.showWarning = true
                            }
                        }) {
                            ZStack {
                                Rectangle()
                                    .cornerRadius(50)
                                    .foregroundColor(Color("CardBG"))
                                    .shadow(color: Color("Shadow"), radius: 10)
                                    .frame(width: 200, height: 80)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(NSLocalizedString("LastR", comment: ""))
                                            .font(.headline)
                                            .foregroundColor(Color("trash"))
                                            .padding(.bottom, 5)
                                        Text(lastTime)
                                            .foregroundColor(Color("trash"))
                                    }
                                    .padding(.leading, 33)
                                    Spacer()
                                    Image(systemName: "chevron.right.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .padding(7)
                                }
                            }
                        }
                        .sheet(isPresented: self.$showSheet) {
                            resultReplay().environmentObject(self.lastResult)
                        }
                        .alert(isPresented: self.$showWarning, content: {
                            Alert(title: Text("Failed"), message: Text("No result"), dismissButton: .default(Text("OK")))
                        })
                        Spacer()
                    }.frame(width: 200, height: 80)
                    .padding(.bottom)
                }
            }
            .padding(.bottom)
            .navigationBarTitle(NSLocalizedString("NBT1", comment: ""))
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
            .frame(maxHeight: 800)
            .offset(x: 0, y: geo.size.height > 800 ? geo.size.height - 780:0)
        }
    }
}
