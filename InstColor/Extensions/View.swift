//
//  View.swift
//  InstColor
//
//  Created by Lei Cao on 10/13/22.
//

import Foundation
import SwiftUI

extension View {
    func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
        self.modifier(MeasureSizeModifier())
            .onPreferenceChange(SizePreferenceKey.self, perform: action)
    }
}
