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
        if let readyTC = UserDefaults.standard.string(forKey: "readyToCopy") {
            readyToCopy = readyTC
        }
        
    }
    pwdHash = UserDefaults.standard.string(forKey: "pwdHash")
    return output
}


struct ContentView: View {
    @State var suc = false
    @State private var PrizeNumberInput = ""
    @State private var MemberNumberInput = ""
    @State private var MemberNamesInput = ""
    @State var selection: Int? = nil
    @State var showalert = false
    @State var showalertCPB = false
    @State var showADDTF = false
    @State var addCmdInput = ""
    @Binding var showSheet: Bool
    @State var showWarning = false
    @State var showLastRButton = true
    @State var showDoneButton = false
    @State var updateNow = false
    @State var updateNumber = false
    @State var showField = false
    @EnvironmentObject var PrizeData: Prizes
    @ObservedObject var lastResult = Prizes(data: dataLoader())
    @State var filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    init(showSheet: Binding<Bool>) {
        self._showSheet = showSheet
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundView = nil
        UITableView.appearance().backgroundView = nil
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 0.8)]
    }
    var body: some View {
        let membernames = Binding<String>(get: {
            self.MemberNamesInput
        }, set: {
            self.MemberNamesInput = $0
            if self.MemberNamesInput != "" {
                if self.MemberNamesInput != NSLocalizedString("RFCB", comment: "") {
                    self.MemberNumberInput = String(MN_counter_handinput(input: self.MemberNamesInput))
                    self.updateNumber = true
                    print(originalMN)
                }
            }
        })
        return GeometryReader { geo in
            NavigationView{
                ZStack {
                    BlurView()
                    VStack {
                        KeyboardHost_offset20(showDoneButton: self.$showDoneButton, showButton: self.$showLastRButton)  {
                            Form {
                                Section {
                                    HStack {
                                        Spacer()
                                        Image("box")
                                            .resizable()
                                            .frame(width: 150, height: 150)
                                            .opacity(1)
                                        Spacer()
                                    }
                                    NewTextField(.constant(NSLocalizedString("MNTF", comment: "")), text: $MemberNumberInput, updateNow: self.$updateNumber, isDisabled: .constant(true))
                                        .padding(.horizontal)
                                    HStack {
//                                        ScrollView(.horizontal, showsIndicators: false) {
                                        NewTextField(.constant(NSLocalizedString("NMTF", comment: "")), text: membernames, updateNow: self.$updateNow, isDisabled: .constant(false), fontColor: UIColor(named: "trash"))
                                                .padding(.leading)
                                                .onTapGesture {
                                                    self.showLastRButton = false
                                                    self.showDoneButton = true
                                                }
//                                        }
                                        .frame(height: 30)
                                        Button(action: {
                                            let Pboard = UIPasteboard.general
                                            if Pboard.string != nil {
                                                self.MemberNamesInput = NSLocalizedString("RFCB", comment: "")
                                                originalMN = Pboard.string!
                                                self.MemberNumberInput = String(MN_counter(input: Pboard.string!))
                                                self.updateNow = true
                                                self.updateNumber = true
                                            }
                                            else {
                                                self.showalertCPB = true
                                            }
                                        },
                                        label: {
                                            Image(systemName: "doc.on.clipboard")
                                        }).foregroundColor(.blue)
                                    }}
                                Section {
                                    HStack {
                                        Text(NSLocalizedString("ADDCT", comment: ""))
                                            .font(.headline)
                                            .padding(.leading)
                                            .foregroundColor(.black)
                                            .opacity(1)
                                        Spacer()
                                        Toggle(isOn: self.$showADDTF) {
                                            Text("")
                                        }.padding(.trailing)
                                    }
                                    if self.showADDTF {
                                        HStack {
                                            NewTextField(.constant(NSLocalizedString("ADDCTF", comment: "")), text: self.$addCmdInput, updateNow: self.$updateNow)
                                                .onTapGesture {
                                                    self.showLastRButton = false
                                                    self.showDoneButton = true
                                                }
                                                
                                            Button(action: {
                                                let Pboard = UIPasteboard.general
                                                if Pboard.string != nil {
                                                    originCmd = Pboard.string!
                                                    self.addCmdInput = NSLocalizedString("RFCB", comment: "")
                                                    updateNow = true
                                                    
                                                }
                                                else {
                                                    self.showalertCPB = true
                                                }
                                            },
                                            label: {
                                                Image(systemName: "doc.on.clipboard").foregroundColor(.blue)
                                            })
                                        }
                                        .transition(.slide)
                                    }
                                }
                            }.opacity(0.93)
                            ZStack {
                                HStack {
                                    NavigationLink(destination: page2_add(PrizeData: self.PrizeData), tag: 1, selection: $selection) {
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
                                                .foregroundColor(.white)
                                        })
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
                                                .foregroundColor(.white)
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
                                        self.filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                                        self.filePath.appendPathComponent("Lottery Result - \(lastTime).csv")
                                        try! readyToCopy.write(to: filePath, atomically: true, encoding: .utf8)
                                        print("1 \(filePath)")
                                        self.showSheet = true
                                    }
                                    else {
                                        self.showWarning = true
                                    }
                                }) {
                                    ZStack {
                                        Rectangle()
                                            .cornerRadius(50)
                                            .foregroundColor(.init(white: 1, opacity: 0.5))
                                            .shadow(color: Color("Shadow"), radius: 10)
                                            .frame(width: 200, height: 80)
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(NSLocalizedString("LastR", comment: ""))
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding(.bottom, 5)
                                                Text(lastTime)
                                                    .foregroundColor(.white)
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
                                    resultReplay(filePath: self.$filePath)
                                }
                                .foregroundColor(.blue)
                                Spacer()
                            }.frame(width: 200, height: 80)
                            .padding(.bottom)
                        }
                        
                    }
                    .navigationBarTitle(NSLocalizedString("NBT1", comment: ""))
                    CustomMessageBox("Clip board is empty", show: self.$showalertCPB)
                    CustomMessageBox("Failed to read text fields", show: self.$showalert)
                    CustomMessageBox("No result", show: self.$showWarning)
                }
            }.navigationViewStyle(StackNavigationViewStyle())
            .padding(.bottom)
            .navigationBarBackButtonHidden(true)
            .background(Color.clear)
            .foregroundColor(.clear)
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
    @State var updateNow = false
    @State var showField = false
    @State var filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    @EnvironmentObject var PrizeData: Prizes
    @ObservedObject var lastResult = Prizes(data: dataLoader())
    @State var updateNumber = false
    var body: some View {
        let membernames = Binding<String>(get: {
            self.MemberNamesInput
        }, set: {
            self.MemberNamesInput = $0
            if self.MemberNamesInput != "" {
                if self.MemberNamesInput != NSLocalizedString("RFCB", comment: "") {
                    self.MemberNumberInput = String(MN_counter_handinput(input: self.MemberNamesInput))
                    self.updateNumber = true
                    print(originalMN)
                }
            }
        })
        return GeometryReader { geo in
            ZStack {
                BlurView()
                VStack {
                    KeyboardHost_offset20(showDoneButton: self.$showDoneButton, showButton: self.$showLastRButton)  {
                        Form {
                            Section {
                                HStack {
                                    Spacer()
                                    Image("box")
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .opacity(1)
                                    Spacer()
                                }
                                NewTextField(.constant(NSLocalizedString("MNTF", comment: "")), text: $MemberNumberInput, updateNow: self.$updateNumber, isDisabled: .constant(true))
                                    .padding(.horizontal)
                                HStack {
//                                        ScrollView(.horizontal, showsIndicators: false) {
                                    NewTextField(.constant(NSLocalizedString("NMTF", comment: "")), text: membernames, updateNow: self.$updateNow, isDisabled: .constant(false), fontColor: UIColor(named: "trash"))
                                            .padding(.leading)
                                            .onTapGesture {
                                                self.showLastRButton = false
                                                self.showDoneButton = true
                                            }
//                                        }
                                    .frame(height: 30)
                                    Button(action: {
                                        let Pboard = UIPasteboard.general
                                        if Pboard.string != nil {
                                            self.MemberNamesInput = NSLocalizedString("RFCB", comment: "")
                                            originalMN = Pboard.string!
                                            self.MemberNumberInput = String(MN_counter(input: Pboard.string!))
                                            self.updateNow = true
                                            self.updateNumber = true
                                        }
                                        else {
                                            self.showalertCPB = true
                                        }
                                    },
                                    label: {
                                        Image(systemName: "doc.on.clipboard")
                                    }).foregroundColor(.blue)
                                }}
                            Section {
                                HStack {
                                    Text(NSLocalizedString("ADDCT", comment: ""))
                                        .font(.headline)
                                        .padding(.leading)
                                        .foregroundColor(.black)
                                        .opacity(1)
                                    Spacer()
                                    Toggle(isOn: self.$showADDTF) {
                                        Text("")
                                    }.padding(.trailing)
                                }
                                if self.showADDTF {
                                    HStack {
                                        NewTextField(.constant(NSLocalizedString("ADDCTF", comment: "")), text: self.$addCmdInput, updateNow: self.$updateNow)
                                            .onTapGesture {
                                                self.showLastRButton = false
                                                self.showDoneButton = true
                                            }
                                            
                                        Button(action: {
                                            let Pboard = UIPasteboard.general
                                            if Pboard.string != nil {
                                                originCmd = Pboard.string!
                                                self.addCmdInput = NSLocalizedString("RFCB", comment: "")
                                                updateNow = true
                                                
                                            }
                                            else {
                                                self.showalertCPB = true
                                            }
                                        },
                                        label: {
                                            Image(systemName: "doc.on.clipboard").foregroundColor(.blue)
                                        })
                                    }
                                    .transition(.slide)
                                }
                            }
                        }.opacity(0.93)
                        ZStack {
                            HStack {
                                NavigationLink(destination: page2_add(PrizeData: self.PrizeData), tag: 1, selection: $selection) {
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
                                            .foregroundColor(.white)
                                    })
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
                                            .foregroundColor(.white)
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
                                    self.filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                                    self.filePath.appendPathComponent("Lottery Result - \(lastTime).csv")
                                    try! readyToCopy.write(to: filePath, atomically: true, encoding: .utf8)
                                    print("1 \(filePath)")
                                    self.showSheet = true
                                }
                                else {
                                    self.showWarning = true
                                }
                            }) {
                                ZStack {
                                    Rectangle()
                                        .cornerRadius(50)
                                        .foregroundColor(.init(white: 1, opacity: 0.5))
                                        .shadow(color: Color("Shadow"), radius: 10)
                                        .frame(width: 200, height: 80)
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(NSLocalizedString("LastR", comment: ""))
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding(.bottom, 5)
                                            Text(lastTime)
                                                .foregroundColor(.white)
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
                                resultReplay(filePath: self.$filePath)
                            }
                            .foregroundColor(.blue)
                            Spacer()
                        }.frame(width: 200, height: 80)
                        .padding(.bottom)
                    }
                    
                }
                .navigationBarTitle(NSLocalizedString("NBT1", comment: ""))
                CustomMessageBox("Clip board is empty", show: self.$showalertCPB)
                CustomMessageBox("Failed to read text fields", show: self.$showalert)
                CustomMessageBox("No result", show: self.$showWarning)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
                
            .background(Color.clear)
            .foregroundColor(.clear)
                .frame(width: geo.size.width, height: geo.size.height)
    }
    }
}


struct host<Content: View>: UIViewControllerRepresentable {
    let content: Content
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIHostingController(rootView: self.content)
        controller.view.backgroundColor = nil
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        return
    }
}

struct ContentView1_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSheet: .constant(false)).environmentObject(Prizes())
    }
}
