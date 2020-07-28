//
//  MN_spliter.swift
//  lottery
//
//  Created by wqhqq on 2020/7/26.
//

import Foundation

func MN_spliter(input: String) -> [String]{
    let output: [String] = input.components(separatedBy: CharacterSet(charactersIn: "\n"))
    return output
}

func MN_spliter_handinput(input: String) -> [String]{
    let output: [String] = input.components(separatedBy: CharacterSet(charactersIn: NSLocalizedString("SYMB", comment: "")))
    return output
}


func MN_counter(input: String) -> Int{
    let output: [String] = input.components(separatedBy: CharacterSet(charactersIn: "\n"))
    let count = output.count - 1
    return count
}
