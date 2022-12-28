//
//  ModalViewModifier.swift
//  InstColor
//
//  Created by Lei Cao on 12/24/22.
//

import SwiftUI

struct SimpleModalViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CloseButtonView()
                }
            }
    }
}
