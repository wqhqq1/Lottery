//
//  MN_spliter.swift
//  lottery_13
//
//  Created by wqhqq on 2020/7/21.
//

import Foundation

func MN_spliter(input: String) -> [String]{
    let output: [String] = input.components(separatedBy: CharacterSet(charactersIn: "\n"))
    return output
}

func MN_spliter_space(input: String) -> [String]{
    let output: [String] = input.components(separatedBy: CharacterSet(charactersIn: " "))
    return output
}


func MN_counter(input: String) -> Int{
    let output: [String] = input.components(separatedBy: CharacterSet(charactersIn: "\n"))
    let count = output.count - 1
    return count
}
