//
//  AG_spliter.swift
//  lottery
//
//  Created by wqhqq on 2020/8/9.
//

import Foundation


func AG_spliter(addCmds: String) -> [Int] {
    var output0: [String] = addCmds.components(separatedBy: CharacterSet(charactersIn: "\r\n"))
    var output1 = [Int](), i = 0
    while i < output0.count {
        if output0[i] == "" {
            output0.remove(at: i)
        }
        i += 1
    }
    i = 0
    while i < output0.count {
        output1.append(Int(output0[i])!)
        i += 1
    }
    return output1
}

func AG_counter(addCmds: String) -> Int {
    var output0: [String] = addCmds.components(separatedBy: CharacterSet(charactersIn: "\r\n"))
    var output1 = [Int](), i = 0
    while i < output0.count {
        if output0[i] == "" {
            output0.remove(at: i)
        }
        i += 1
    }
    i = 0
    while i < output0.count {
        output1.append(Int(output0[i])!)
        i += 1
    }
    return output1.count
}
