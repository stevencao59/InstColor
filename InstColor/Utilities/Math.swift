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

func calculate3dDistance(point1: (x: CGFloat, y: CGFloat, z: CGFloat), point2: (x: CGFloat, y: CGFloat, z: CGFloat)) -> CGFloat {
    let sum1 = pow(point2.x - point1.x, 2)
    let sum2 = pow(point2.y - point1.y, 2)
    let sum3 = pow(point2.z - point1.z, 2)
    return sqrt(sum1 + sum2 + sum3)
}
