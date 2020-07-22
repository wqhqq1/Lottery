//
//  page3_confirm.swift
//  lottery_13
//
//  Created by wqhqq on 2020/7/20.
//

import SwiftUI

var AllPrizesMember: Int = 0, rands = [Int]()


struct page3_confirm: View {
    @State var selection: Int? = nil
    var body: some View {
        List {
            ForEach(Prizes) { pri in
                VStack{
                Text(pri.PrizeName)
//                    .padding()
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Text("\(NSLocalizedString("QTT", comment: ""))\(pri.PrizeMember)")
                    .multilineTextAlignment(.leading)
                }
            }
        }.navigationBarTitle(NSLocalizedString("NBPV", comment: ""))
        NavigationLink(
            destination: page4_result(), tag: 1, selection: $selection)
        {
            Button(action: {
                AllPrizesMember = APM_ccltor()
                rands = Random(start: 1, end: AllPrizesMember + 1, Members: MemberNumber)
                var i = 0, j = 0
                while i < PrizeNumber {
                    if i == 0{
                    Prizes[i].PrizeM = Prizes[i].PrizeMember
                    }
                    while j < Prizes[i].PrizeM {
                        Prizes[i].Lottery_result += "\n" + MemberNames[rands[j] - 1] + " "
                        j += 1
                        }
                    i += 1
                    if i != PrizeNumber {
                    Prizes[i].PrizeM = Prizes[i - 1].PrizeM + Prizes[i].PrizeMember
                    }}
                selection = 1
            }, label: {
                btnADD()
            })
        }

    }
}

struct btnADD: View {
    var size: CGFloat = 65.0
    var body: some View {
        ZStack{
            Group {
                Circle()
                    .fill(Color.red)
                    .shadow(radius: 10)
            }.frame(width: self.size, height: self.size)
            Group {
                Text(NSLocalizedString("GOB", comment: ""))
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
    }
}


struct page3_confirm_Previews: PreviewProvider {
    static var previews: some View {
        page3_confirm()
    }
}
