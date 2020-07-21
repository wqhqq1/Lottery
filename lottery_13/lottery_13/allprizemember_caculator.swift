//
//  allprizemember_caculator.swift
//  lottery_13
//
//  Created by wqhqq on 2020/7/20.
//

import Foundation

func APM_ccltor() -> Int {
    var i = 0, APM = 0
    while i < PrizeNumber {
        APM += Prizes[i].PrizeMember
        i += 1
    }
    return APM
}
