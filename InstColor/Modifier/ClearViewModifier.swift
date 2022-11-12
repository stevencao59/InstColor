//
//  ClearViewModifier.swift
//  InstColor
//
//  Created by Lei Cao on 11/8/22.
//

import SwiftUI

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

struct ClearBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(ClearBackgroundView())
    }
}

