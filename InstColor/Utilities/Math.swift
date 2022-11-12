//
//  Math.swift
//  InstColor
//
//  Created by Lei Cao on 11/11/22.
//

import Foundation

infix operator %%

func %%(left: Double, right: Double) -> Double {
    let remainder = left.truncatingRemainder(dividingBy: right)
    let result = remainder < 0 ? right + remainder : remainder
    return result
}


