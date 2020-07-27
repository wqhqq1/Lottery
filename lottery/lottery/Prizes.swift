//
//  Prizes.swift
//  lottery
//
//  Created by wqhqq on 2020/7/25.
//

import Foundation

class Prizes: ObservableObject {
    @Published var PrizeList: [SinglePrize]
    var PrizeList_cacu: [SinglePrize] = []
    var count = 0
    
    init()
    {
        self.PrizeList = []
    }
    
    func reAppend() {
        PrizeList_cacu = []
        var i = 0, count_1 = 0
        while i < PrizeList.count {
            if PrizeList[i].isRemoved == false {
                PrizeList_cacu.append(SinglePrize(id: count_1, PrizeName: PrizeList[i].PrizeName, PrizeMember: PrizeList[i].PrizeMember))
                count_1 += 1
            }
            i += 1
        }
        
        i = 0
        while i < PrizeList_cacu.count {
            if i == 0 {
                PrizeList_cacu[i].PrizeM = PrizeList_cacu[i].PrizeMember
            }
            else {
                PrizeList_cacu[i].PrizeM = PrizeList_cacu[i].PrizeMember + PrizeList_cacu[i - 1].PrizeM
            }
            i += 1
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
        reAppend()
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
        reAppend()
    }
    
    func remove(index: Int) {
        PrizeList[index].isRemoved.toggle()
        reAppend()
    }
    
    func removeMore(index: [Int]) {
        for i in index {
            PrizeList[i].isRemoved.toggle()
        }
        reAppend()
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
