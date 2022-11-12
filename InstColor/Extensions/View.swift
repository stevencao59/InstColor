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
}
