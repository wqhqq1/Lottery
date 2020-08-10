//
//  Prizes.swift
//  lottery
//
//  Created by wqhqq on 2020/7/25.
//

import Foundation
import SwiftUI

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
                PrizeList_cacu.append(SinglePrize(id: count_1, PrizeName: PrizeList[i].PrizeName, PrizeMember: PrizeList[i].PrizeMember, maxCmd: PrizeList[i].maxCmd, minCmd: PrizeList[i].minCmd, enabledCmds: PrizeList[i].enabledCmds))
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
    
    func head() -> Int {
        var head = 0
        while head < PrizeList.count {
            if PrizeList[head].isRemoved == false {
                return PrizeList[head].id
            }
            head += 1
        }
        return 0
    }
    
    func upNearBy(index: Int) -> Int {
        var nearBy = index - 1
        while nearBy >= 0 {
            if PrizeList[nearBy].isRemoved == false {
                return nearBy
            }
            nearBy -= 1
        }
        return 0
    }
    
    func end() -> Int {
        var end = PrizeList.count - 1
        while end >= 0 {
            if PrizeList[end].isRemoved == false {
                return PrizeList[end].id
            }
            end -= 1
        }
        return 0
    }
    
    func downNearBy(index: Int) -> Int {
        var nearBy = index + 1
        while nearBy < PrizeList.count {
            if PrizeList[nearBy].isRemoved == false {
                return nearBy
            }
            nearBy += 1
        }
        return 0
    }
    
    func add(data: SinglePrize) {
        if count == 0 {
            PrizeList.append(SinglePrize(id: count, PrizeName: data.PrizeName, PrizeMember: data.PrizeMember, PrizeM: data.PrizeMember, maxCmd: data.maxCmd, minCmd: data.minCmd, enabledCmds: data.enabledCmds))
        }
        else {
            PrizeList.append(SinglePrize(id: count, PrizeName: data.PrizeName, PrizeMember: data.PrizeMember, PrizeM: PrizeList[count - 1].PrizeM + data.PrizeMember, maxCmd: data.maxCmd, minCmd: data.minCmd, enabledCmds: data.enabledCmds))
        }
        count += 1
        reAppend()
    }
    
    func move(from: Int, to: Int) {
        let tempPrize = PrizeList[from]
        PrizeList[from].PrizeName = PrizeList[to].PrizeName
        PrizeList[from].PrizeMember = PrizeList[to].PrizeMember
        PrizeList[from].enabledCmds = PrizeList[to].enabledCmds
        PrizeList[from].maxCmd = PrizeList[to].maxCmd
        PrizeList[from].minCmd = PrizeList[to].minCmd
        PrizeList[to].PrizeMember = tempPrize.PrizeMember
        PrizeList[to].PrizeName = tempPrize.PrizeName
        PrizeList[to].maxCmd = tempPrize.maxCmd
        PrizeList[to].minCmd = tempPrize.minCmd
        PrizeList[to].enabledCmds = tempPrize.enabledCmds
        reAppend()
    }
    
    func edit(index: Int, data: SinglePrize) {
        var i = PrizeList[index].id + 1
        if index == 0 {
            PrizeList[index] = SinglePrize(id: PrizeList[index].id, PrizeName: data.PrizeName, PrizeMember: data.PrizeMember, PrizeM: data.PrizeMember,maxCmd: data.maxCmd , minCmd: data.minCmd, enabledCmds: data.enabledCmds)
        }
        else {
            PrizeList[index] = SinglePrize(id: PrizeList[index].id, PrizeName: data.PrizeName, PrizeMember: data.PrizeMember, PrizeM: PrizeList[index - 1].PrizeM + data.PrizeMember, maxCmd: data.maxCmd, minCmd: data.minCmd, enabledCmds: data.enabledCmds)
        }
        while i < PrizeList.count {
            PrizeList[i].PrizeM = PrizeList[i - 1].PrizeM + PrizeList[i].PrizeMember
            i += 1
        }
        reAppend()
    }
    
    func remove(index: Int) {
        withAnimation{
            PrizeList[index].isRemoved.toggle()
        }
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
    var maxCmd: Int? = nil
    var minCmd: Int? = nil
    var enabledCmds = false
}
