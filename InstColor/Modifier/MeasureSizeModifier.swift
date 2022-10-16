//
//  MeasureSizeModifier.swift
//  InstColor
//
//  Created by Lei Cao on 10/13/22.
//

import Foundation
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct MeasureSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(GeometryReader {geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        })
    }
}
