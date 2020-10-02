//
//  Replay.swift
//  lottery
//
//  Created by wqhqq on 2020/8/25.
//

import SwiftUI

var MemberNumber = 0, i: Int = 0, MemberNames = [String](), originalMN = "", originalMemberNames = "", addCmd = [Int](), addedCmd = false, originCmd = "", lastTime = "Failed"
var sheetModeResult = false

struct resultReplay: View {
    @ObservedObject var PrizeData = Prizes(data: dataLoader())
    @State var filePathInput = ""
    @State var selection: Int? = nil
    @State var alertText = ""
    @State var showSavedAlert = false
    @State var showShareSheet = false
    @Binding var filePath: URL
    @Environment(\.presentationMode) var presentation
    var body: some View {
        print("1 \(filePath)")
        return GeometryReader{ geo in NavigationView {
            ZStack {
                BlurView()
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading) {
                        Text(sheetModeResult ? lastTime:NSLocalizedString("NBLR", comment: "")).font(Font.custom("", size: 40)).foregroundColor(.init(white: 1, opacity: 0.8))
                        ForEach(self.PrizeData.PrizeList_cacu) { prize in
                            SingleResultReplay(index: prize.id)
                                .environmentObject(self.PrizeData)
                                .frame(height: 80)
                                .animation(.spring())
                        }.animation(.spring())
                    }.padding(.horizontal)
                    .animation(.spring())
                }.padding()
                VStack {
                    Spacer()
                    Button(action: {
                        if isMac {
                            var path = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
                            path.appendPathComponent("Lottery Result - \(lastTime) +\(arc4random()).csv")
                            try? readyToCopy.write(to: path, atomically: true, encoding: .utf8)
                            self.showSavedAlert = true
                        }
                        else {
                            self.showShareSheet = true
                        }
                    }) {
                        HStack {
                            Text(NSLocalizedString("CPR", comment: ""))
                            Image(systemName: "square.and.arrow.down.fill")
                                .imageScale(.large)
                        }.foregroundColor(.white)
                    }
                    .padding(.bottom)
                    .shadow(color: Color("Shadow"), radius: 10)
                    .sheet(isPresented: self.$showShareSheet, content: {
                        ShareSheet([filePath])
                    })
                    if urlModeResult {
                        NavigationLink(destination: ContentView(showSheet: .constant(false)), tag: 1, selection: $selection) {
                            Button(action: {
                                urlModeResult = false
                                sheetModeResult = false
                                self.selection = 1
                            }) {
                                Text(NSLocalizedString("DONE", comment: "")).foregroundColor(.white)
                            }
                        }
                    }
                    else {
                        if sheetModeResult {
                            Button(action: {
                                self.presentation.wrappedValue.dismiss()
                                sheetModeResult = false
                            }) {
                                Text(NSLocalizedString("DONE", comment: "")).foregroundColor(.white)
                            }.padding()
                        }
                    }
                }.padding(.all, 50)
                CustomMessageBox("Successfully Saved", show: self.$showSavedAlert)
            }.padding().background(Color.clear)
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)
        }.frame(width: geo.size.width + 50, height: geo.size.height + 80).offset(x: -20, y: -20)}
        
    }
}

struct resultPageRePlay: View {
    var prize: String
    var result: String
    @Environment(\.presentationMode) var presentation
    var body: some View {
        GeometryReader { geo in
            ZStack{
                BlurView()
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                            .frame(width: 30, height: 0)
                    }
                    Form {
                        Section {
                            Text("\(NSLocalizedString("CT", comment: ""))\(result)\(NSLocalizedString("GT", comment: ""))\(self.prize)")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        Section {
                            Button(action: {
                                self.presentation.wrappedValue.dismiss()
                            }) {
                                Text(NSLocalizedString("EXT", comment: "Done"))
                            }
                        }
                    }.navigationBarHidden(false).navigationBarTitle(self.prize)
                }.padding(.all, 30)}.frame(width: geo.size.width + 50, height: geo.size.height + 80).offset(x: -20, y: -20)}
        
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
                    .foregroundColor(.white)
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
            }
            .background(Color(white: 1, opacity: 0.2))
            .cornerRadius(10)
            .padding(.bottom)
            .shadow(color: Color("Shadow"), radius: 10, x: 0, y: 10)
        }.sheet(isPresented: $showResultPage) {
            resultPageRePlay(prize: self.PrizeList.PrizeList_cacu[self.index].PrizeName, result: self.PrizeList.PrizeList_cacu[self.index].Lottery_result)
        }}
}


struct Replay_Previews: PreviewProvider {
    static var previews: some View {
        resultReplay(filePath: .constant(URL(string: "file://")!)).environmentObject(Prizes(data: [SinglePrize(PrizeName: "123", PrizeMember: 10)]))
    }
}

