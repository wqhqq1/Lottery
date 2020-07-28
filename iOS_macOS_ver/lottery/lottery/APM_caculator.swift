//
//  APM_caculator.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import Foundation

func APM_ccltor(data: [SinglePrize]) -> Int {
    var i = 0, APM = 0
    while i < data.count {
        APM += data[i].PrizeMember
        i += 1
    }
    return APM
}
