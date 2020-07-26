//
//  Prizes.swift
//  lottery
//
//  Created by wqhqq on 2020/7/25.
//

import Foundation

class Prizes: ObservableObject {
    @Published var PrizeList: [SinglePrize]
    var count = 0
    
    init()
    {
        self.PrizeList = []
    }
    
    init(data: [SinglePrize])
    {
        self.PrizeList = []
        for prize in data {
            self.PrizeList.append(SinglePrize(id: count, PrizeName: prize.PrizeName, PrizeMember: prize.PrizeMember))
            count += 1
        }
        for prize in self.PrizeList {
            if prize.id == 0 {
                self.PrizeList[prize.id].PrizeM = self.PrizeList[prize.id].PrizeMember
            }
            else {
                self.PrizeList[prize.id].PrizeM += self.PrizeList[prize.id - 1].PrizeM + self.PrizeList[prize.id].PrizeMember
            }
        }
    }
    
    func add(data: SinglePrize) {
        if count == 0 {
            PrizeList.append(SinglePrize(id: count, PrizeName: data.PrizeName, PrizeMember: data.PrizeMember, PrizeM: data.PrizeMember))
        }
        else {
            PrizeList.append(SinglePrize(id: count, PrizeName: data.PrizeName, PrizeMember: data.PrizeMember, PrizeM: PrizeList[count - 1].PrizeM + data.PrizeMember))
        }
        count += 1
    }
    
    func edit(index: Int, data: SinglePrize) {
        var i = PrizeList[index].id + 1
        if index == 0 {
            PrizeList[index] = SinglePrize(id: PrizeList[index].id, PrizeName: data.PrizeName, PrizeMember: data.PrizeMember, PrizeM: data.PrizeMember)
        }
        else {
            PrizeList[index] = SinglePrize(id: PrizeList[index].id, PrizeName: data.PrizeName, PrizeMember: data.PrizeMember, PrizeM: PrizeList[index - 1].PrizeM + data.PrizeMember)
        }
        while i < PrizeList.count {
            PrizeList[i].PrizeM = PrizeList[i - 1].PrizeM + PrizeList[i].PrizeMember
            i += 1
        }
    }
}

struct SinglePrize: Identifiable {
    var id = 0
    var isRemoved = false
    var PrizeName: String
    var PrizeMember: Int
    var PrizeM = 0
    var Lottery_result: String = ""
}
