//
//  View.swift
//  InstColor
//
//  Created by Lei Cao on 11/8/22.
//

import SwiftUI

extension View {
    func clearModalBackground() -> some View {
        self.modifier(ClearBackgroundViewModifier())
    }
    
    func defocusOnTap<T>(_ focusField: FocusState<T?>.Binding) -> some View {
        self
            .contentShape(Rectangle())
            .onTapGesture {
                focusField.wrappedValue = nil
            }
    }
}
