//
//  Array.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import Foundation

struct Stack<T>: CustomStringConvertible {
    var items: [T] = []
    
    var description: String {
        return "---- Stack begin ----\n" + items.map({ "\($0)"}).joined(separator: "\n") + "---- Stack End ----"
    }
    
    mutating func push(_ item: T) {
        self.items.insert(item, at: 0)
    }
    
    mutating func pop() -> T? {
        if items.isEmpty { return nil }
        return self.items.removeFirst()
    }
    
    func peek() -> T? {
        return self.items.first
    }
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    mutating func appendLimit(item: Element, limit: Int) {
        if self.count == limit {
            self.removeFirst()
        }
        self.append(item)
    }
}
