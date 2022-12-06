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

func lerp(from a: CGFloat, to b: CGFloat, alpha: CGFloat) -> CGFloat {
    return (1 - alpha) * a + alpha * b
}

func clamp(value: CGFloat, greater: CGFloat, less: CGFloat) -> CGFloat {
    return value < greater ? greater : value > less ? less : value
}
