//
//  prizes.swift
//  lottery_13
//
//  Created by wqhqq on 2020/7/20.
//

import Foundation

struct prizes: Identifiable {
    var id = UUID()
    var PrizeName: String
    var PrizeMember: Int
    var PrizeM = 0
    var Lottery_result: String = ""
}
