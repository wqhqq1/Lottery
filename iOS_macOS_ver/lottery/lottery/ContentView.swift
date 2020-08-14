//
//  ContentView.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import SwiftUI

var MemberNumber = 0, i: Int = 0, MemberNames = [String](), originalMN = "", readyToCopy = "", originalMemberNames = "", addCmd = [Int](), addedCmd = false, originCmd = "", lastTime = "Failed"
func dataLoader() -> [SinglePrize] {
    var output: [SinglePrize] = []
    if let data = UserDefaults.standard.object(forKey: "PrizeList_cacu") as? Data {
        output = try! decoder.decode([SinglePrize].self, from: data)
        let time = UserDefaults.standard.string(forKey: "theDate")
        lastTime  = time!
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
            VStack {
                KeyboardHost_offset20  {
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
                    }}
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
    @State var showSheet = false
    @State var showWarning = false
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
        return VStack {
            KeyboardHost_offset20  {
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
                }}
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
        .navigationBarTitle(NSLocalizedString("NBT1", comment: ""))
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
}


struct resultReplay: View {
    @EnvironmentObject var PrizeData: Prizes
    @State var showAlert = false
    @State var filePathInput = ""
    @Environment(\.presentationMode) var presentation
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        ForEach(self.PrizeData.PrizeList_cacu) { prize in
                            SingleResultReplay(index: prize.id)
                                .environmentObject(self.PrizeData)
                                .frame(height: 80)
                                .animation(.spring())
                        }.animation(.spring())
                    }.padding(.horizontal)
                    .animation(.spring())
                }.navigationBarTitle(sheetModeResult ? lastTime:NSLocalizedString("NBLR", comment: ""))
                .navigationBarBackButtonHidden(true)
                VStack {
                    Spacer()
                    Button(action: {
                        self.showAlert = true
                    }) {
                        HStack {
                            Text(NSLocalizedString("CPR", comment: ""))
                            Image(systemName: "square.and.arrow.down.fill")
                                .imageScale(.large)
                        }
                    }.background(AlertControl(show: self.$showAlert, title: "Save", message: "Input file name."))
                    .padding(.bottom)
                    .shadow(color: Color("Shadow"), radius: 10)
                    if sheetModeResult {
                        Button(action: {
                            sheetModeResult = false
                            self.presentation.wrappedValue.dismiss()
                        }) {
                            Text(NSLocalizedString("DONE", comment: ""))
                        }.padding()
                    }
                }
            }.padding()
        }
    }
}

struct resultPageRePlay: View {
    var prize: String
    var result: String
    @Environment(\.presentationMode) var presentation
    var body: some View {
        
        VStack {
            Form {
                Section {
                    Text("\(NSLocalizedString("CT", comment: ""))\(result)\(NSLocalizedString("GT", comment: ""))\(self.prize)")
                        .font(.title)
                }
                Section {
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text(NSLocalizedString("EXT", comment: "Done"))
                    }
                }
            }
        }.navigationBarTitle(self.prize)
        
    }
}

struct SingleResultReplay: View {
    @State var showResultPage = false
    @EnvironmentObject var PrizeList: Prizes
    var index: Int
    var body: some View {
        var range = ""
        if self.PrizeList.PrizeList_cacu[index].enabledCmds && self.PrizeList.PrizeList_cacu[index].maxCmd != nil && self.PrizeList.PrizeList_cacu[index].minCmd != nil {
            if self.PrizeList.PrizeList_cacu[index].minCmd == self.PrizeList.PrizeList_cacu[index].maxCmd {
                range = "(=" + String(self.PrizeList.PrizeList_cacu[index].minCmd!) + ")"
            }
            else {
                range = "(" + String(self.PrizeList.PrizeList_cacu[index].minCmd!) + "≤,≤" + String(self.PrizeList.PrizeList_cacu[index].maxCmd!) + ")"
            }
        }
        return Button(action: {
            self.showResultPage = true
        }) {
            HStack {
                Rectangle()
                    .frame(width: 6)
                    .foregroundColor(.blue)
                VStack(alignment: .leading, spacing: 6.0) {
                    HStack {
                        Text(self.PrizeList.PrizeList_cacu[self.index].PrizeName)
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        Text(range)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("arrow"))
                    .padding()
            }.background(Color("CardBG"))
                .cornerRadius(10)
                .padding(.bottom)
                .shadow(color: Color("Shadow"), radius: 10, x: 0, y: 10)
        }.sheet(isPresented: $showResultPage) {
            resultPageRePlay(prize: self.PrizeList.PrizeList_cacu[self.index].PrizeName, result: self.PrizeList.PrizeList_cacu[self.index].Lottery_result)
        }}
}
