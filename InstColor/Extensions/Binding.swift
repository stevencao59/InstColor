//
//  Binding.swift
//  InstColor
//
//  Created by Lei Cao on 2/8/23.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(get: {
            self.wrappedValue
            
        }, set: { newValue in
            self.wrappedValue = newValue
            handler(newValue)
        })
    }
}
