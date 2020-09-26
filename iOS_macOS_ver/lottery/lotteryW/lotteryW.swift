//
//  lotteryW.swift
//  lotteryW
//
//  Created by wqhqq on 2020/8/25.
//

import WidgetKit
import SwiftUI
import Intents

func returnPwdState() -> Bool {
    var sharedDir = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.lotterywiget")!
    sharedDir.appendPathComponent("pwdState")
    let string = try? String(contentsOf: sharedDir)
    if let str = string {
        if str == "1" {
            return true
        }
    }
    return false
}

func returnRange(_ Data: SinglePrize) -> String {
    var range: String = ""
    if Data.enabledCmds && Data.maxCmd != nil && Data.minCmd != nil {
        if Data.minCmd == Data.maxCmd {
            range = "(=" + String(Data.minCmd!) + ")"
        }
        else {
            range = "(" + String(Data.minCmd!) + "≤,≤" + String(Data.maxCmd!) + ")"
        }
    }
    return range
}

struct Provider: TimelineProvider {
    
    func returnDate() -> String {
        let dateDir = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.lotterywiget")!.path
        let datePath = dateDir + "/Date"
        let Date = try? NSString(contentsOfFile: datePath, encoding: String.Encoding.utf8.rawValue)
        return Date != nil ? Date! as String:"Failed"
    }
    
    func returnData() -> Prizes {
        let dataPath = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.lotterywiget")!.appendingPathComponent("Data")
        print(dataPath)
        let dataSaved = try? Data(contentsOf: dataPath)
        var PrizeData = try? decoder.decode([SinglePrize].self, from: dataSaved!)
        if returnPwdState() {
            PrizeData = [SinglePrize(PrizeName: "Data was encrypted", PrizeMember: 0)]
        }
        return PrizeData != nil ? Prizes(data: PrizeData!):Prizes()
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), lastDate: "00-00", PrizeData: Prizes(data: [SinglePrize(PrizeName: "0000", PrizeMember: 10)]))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), lastDate: returnDate(), PrizeData: returnData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let date = Date()
        let entry = SimpleEntry(date: date, lastDate: returnDate(), PrizeData: returnData())
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: date)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let lastDate: String
    @ObservedObject var PrizeData: Prizes
}

struct TimeViewSmall: View {
    var entry: Provider.Entry
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.yellow)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image("Head")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                    Text("LotteryAPP")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                VStack(alignment: .leading) {
                    Text("Last Result")
                        .font(.title2)
                    Text("Date:\(entry.lastDate)")
                        .font(.title3)
                }
                ZStack {
                    HStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: 140, height: 50)
                            .cornerRadius(25)
                    }
                    HStack {
                        Text("Open App")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
    }
}

struct TimeViewMid: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.yellow)
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        Spacer()
                        HStack {
                            Image("Head")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            Text("Lottery")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                                Text("Last Result")
                                    .font(.subheadline)
                                Text("Date:\(entry.lastDate)")
                                    .font(.subheadline)
                        
                        
                        ZStack {
                            HStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(width: 110, height: 50)
                                    .cornerRadius(25)
                            }
                            HStack {
                                Text("Open")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Image(systemName: "chevron.right.circle.fill")
                                    .resizable()
                                    .foregroundColor(.blue)
                                    .frame(width: 40, height: 40)
                            }
                        }
                        Spacer()
                    }
                    Divider()
                        .foregroundColor(.black)
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("包含的奖项")
                                .font(.headline)
                            Text("(\(entry.PrizeData.PrizeList_cacu.count > 4 ? 4:entry.PrizeData.PrizeList_cacu.count) of \(entry.PrizeData.PrizeList_cacu.count))")
                                .font(.subheadline)
                        }
                        .padding(.bottom, 2)
                        HStack {
                            VStack(alignment: .leading) {
                                ForEach(self.entry.PrizeData.PrizeList_cacu) { Prize in
                                    if Prize.id < 3 {
                                        Text("\(Prize.PrizeName): \(Prize.PrizeMember)人\(returnRange(Prize))")
                                            .font(.subheadline)
                                            .padding(.bottom, 0.1)
                                    }
                                    if Prize.id == 3 {
                                        Text("\(Prize.PrizeName): \(Prize.PrizeMember)人\(returnRange(Prize))\(entry.PrizeData.PrizeList_cacu.count > 4 ? "...":"")")
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }.padding([.top], 3)
                }
                Spacer()
            }.padding()
        }
    }
}

struct TimeViewLarge: View {
    var entry: Provider.Entry
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.yellow)
            VStack {
                HStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image("Head")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            Text("LotteryAPP")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        VStack(alignment: .leading) {
                            Text("Last Result")
                                .font(.subheadline)
                                .fontWeight(.heavy)
                            Text("Date:\(entry.lastDate)")
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                        .frame(width:10)
                    ZStack {
                        HStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(width: 150, height: 50)
                                .cornerRadius(25)
                        }
                        HStack {
                            Text("Show in App")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Image(systemName: "chevron.right.circle.fill")
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                Divider()
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Result(\(entry.PrizeData.PrizeList_cacu.count > 3 ? 3:entry.PrizeData.PrizeList_cacu.count) of \(entry.PrizeData.PrizeList_cacu.count))")
                            .font(.title3)
                            .fontWeight(.heavy)
                            .padding(.bottom, 3)
                        ForEach(entry.PrizeData.PrizeList_cacu) { Prize in
                            if Prize.id < 2 {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(Prize.PrizeName):")
                                            .font(.headline)
                                            .padding(.bottom, 1)
                                        Text("\(Prize.PrizeMember)人\(returnRange(Prize))")
                                            .font(.headline)
                                            .padding(.bottom, 1)
                                    }
                                    Text("Winners: \(Prize.Lottery_result)")
                                        .font(.subheadline)
                                        .padding(.bottom, 2)
                                }
                            }
                            if Prize.id == 2 {
                                VStack(alignment: .leading) {
                                    Text("\(Prize.PrizeName): \(Prize.PrizeMember)人\(returnRange(Prize))")
                                        .font(.headline)
                                        .padding(.bottom, 1)
                                    Text("Winners: \(Prize.Lottery_result)\(entry.PrizeData.PrizeList_cacu.count > 3 ? "\n...":"")")
                                        .font(.subheadline)
                                        .padding(.bottom, 2)
                                }
                            }
                        }.padding(.bottom, 2)
                    }
                    Spacer()
                }.padding([.leading, .trailing])
                Spacer()
            }.padding(.top)
        }
    }
}

struct lotteryWEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    var url: URL = URL(string: "lottery://result")!
    var body: some View {
        switch family {
        case .systemLarge: TimeViewLarge(entry: self.entry).widgetURL(self.url)
        case .systemMedium: TimeViewMid(entry: self.entry).widgetURL(self.url)
        default: TimeViewSmall(entry: self.entry).widgetURL(self.url)
        }
    }
}

@main
struct lotteryW: Widget {
    let kind: String = "com.kirin.lotteryW"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            lotteryWEntryView(entry: entry)
        }
        .configurationDisplayName("Lottery")
        .description("Show last lottery result.")
        .supportedFamilies([.systemLarge, .systemMedium, .systemSmall])
    }
}

struct lotteryW_Previews: PreviewProvider {
    static var previews: some View {
        lotteryWEntryView(entry: SimpleEntry(date: Date(), lastDate: "8-8", PrizeData: Prizes(data: [SinglePrize(id: 0, PrizeName: "一等奖", PrizeMember: 1, maxCmd: 10, minCmd: 10, enabledCmds: true), SinglePrize(id: 1, PrizeName: "二等奖", PrizeMember: 2, maxCmd: 11, minCmd: 10, enabledCmds: true), SinglePrize(id: 2, PrizeName: "三等奖", PrizeMember: 2, maxCmd: 11, minCmd: 10, enabledCmds: true), SinglePrize(id: 3, PrizeName: "鼓励奖", PrizeMember: 2, maxCmd: 11, minCmd: 10, enabledCmds: true)])))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
