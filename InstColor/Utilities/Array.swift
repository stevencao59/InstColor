//
//  Array.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import Foundation

func getNElementArray<T>(elements: [T], onEvery: Int) -> [[T]]{
    var result: [[T]] = []
    
    for i in 0..<elements.count {
        result[i % onEvery].append(elements[i])
    }
    
    return result
}
