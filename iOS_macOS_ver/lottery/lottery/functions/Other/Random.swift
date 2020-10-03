//
//  Random.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import Foundation

func Random(start: Int, end: Int, Members: Int) -> [Int] {
    let scope = end - start
    var startArr = Array(1...Members)
    var resultArr = Array(repeating: 0, count: scope)
    for i in 0..<resultArr.count {
        let currentCount = UInt32(startArr.count - i)
        let index = Int(arc4random_uniform(currentCount))
        resultArr[i] = startArr[index]
        startArr[index] = startArr[Int(currentCount) - 1]
    }
    return resultArr
}
