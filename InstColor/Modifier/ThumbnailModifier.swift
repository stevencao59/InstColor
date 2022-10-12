//
//  ThumbnailModifier.swift
//  InstColor
//
//  Created by Lei Cao on 10/11/22.
//

import Foundation
import SwiftUI

struct ThumbnailModifier: ViewModifier {
    @State private var location: CGPoint = .zero
    
    var tapGesture: some Gesture {
        SpatialTapGesture().onEnded { event in
            location = event.location
        }
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
                .gesture(tapGesture)
        }
    }
}
