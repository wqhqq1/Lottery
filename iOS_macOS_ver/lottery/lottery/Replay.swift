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
    @EnvironmentObject var PrizeData: Prizes
    @State var filePathInput = ""
    @State var selection: Int? = nil
    @State var alertText = ""
    @State var showSavedAlert = false
    @Binding var filePath: URL
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
                        print("2 \(filePath)")
                        self.showSavedAlert = true
                    }) {
                        HStack {
                            Text(NSLocalizedString("CPR", comment: ""))
                            Image(systemName: "square.and.arrow.down.fill")
                                .imageScale(.large)
                        }
                    }
                    .padding(.bottom)
                    .shadow(color: Color("Shadow"), radius: 10)
                    .sheet(isPresented: self.$showSavedAlert, content: {
                        ShareSheet([filePath])
                    })
                    if urlModeResult {
                        NavigationLink(destination: ContentView(showSheet: false), tag: 1, selection: $selection) {
                            Button(action: {
                                urlModeResult = false
                                sheetModeResult = false
                                self.selection = 1
                            }) {
                                Text(NSLocalizedString("DONE", comment: ""))
                            }
                        }
                    }
                    else {
                        if sheetModeResult {
                            Button(action: {
                                self.presentation.wrappedValue.dismiss()
                                sheetModeResult = false
                            }) {
                                Text(NSLocalizedString("DONE", comment: ""))
                            }.padding()
                        }
                    }
                }
            }.padding()
            .navigationViewStyle(StackNavigationViewStyle())
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


struct Replay_Previews: PreviewProvider {
    static var previews: some View {
        resultReplay(filePath: .constant(URL(string: "file://")!)).environmentObject(Prizes(data: [SinglePrize(PrizeName: "123", PrizeMember: 10)]))
    }
}

