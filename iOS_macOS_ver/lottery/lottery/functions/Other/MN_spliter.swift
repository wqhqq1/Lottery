//
//  MN_spliter.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import Foundation

func MN_spliter(input: String) -> [String]{
    var output: [String] = input.components(separatedBy: CharacterSet(charactersIn: "\r\n"))
    var i = 0
    while i < output.count {
        if output[i] == "" {
            output.remove(at: i)
        }
        i += 1
    }
    return output
}

func MN_spliter_handinput(input: String) -> [String]{
    var output: [String] = input.components(separatedBy: CharacterSet(charactersIn: NSLocalizedString("SYMB", comment: "")))
    while i < output.count {
        if output[i] == "" {
            output.remove(at: i)
        }
        i += 1
    }
    return output
}


func MN_counter(input: String) -> Int{
    var output: [String] = input.components(separatedBy: CharacterSet(charactersIn: "\r\n"))
    while i < output.count {
        if output[i] == "" {
            output.remove(at: i)
        }
        i += 1
    }
    let count = output.count
    return count
}

func MN_counter_handinput(input: String) -> Int{
    var output: [String] = input.components(separatedBy: CharacterSet(charactersIn: NSLocalizedString("SYMB", comment: "")))
    while i < output.count {
        if output[i] == "" {
            output.remove(at: i)
        }
        i += 1
    }
    for out in output {
        print(out)
    }
    return output.count
}
